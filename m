Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYGTWAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYGTWAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYGTWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:00:43 -0400
Received: from eazy.amigager.de ([213.239.192.238]:37418 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYGTWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:00:42 -0400
Date: Mon, 21 Jul 2008 00:01:40 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: no direct rendering with 2.6.26 due to AGP after DRM
Message-ID: <20080720220140.GA14818@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org, airlied@linux.ie
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 2.6.26, I got no direct OpenGL rendering in Xorg. A look into the
dmesg lock revealed this:

2.6.26:

[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm:drm_fill_in_dev] *ERROR* Cannot initialize the agpgart module.
DRM: Fill_in_dev failed.
...
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000

2.6.25.9:

Linux agpgart interface v0.103
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0

Any hints what I could try to solve this?

Regards,
Tino
