Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0AQRBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0AQRBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759Ab0AQRBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:01:09 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49613 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752422Ab0AQRBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:01:06 -0500
Date: Sun, 17 Jan 2010 12:00:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: dri-devel@lists.sourceforge.net
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Font selection with i915
Message-ID: <Pine.LNX.4.44L0.1001171154220.21718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Fedora 12 loads i915 during initramfs probing on my system, the
driver automatically installs a tiny 160x64 font.  How can I prevent it
from doing this, or tell it to use a larger 80x25 font instead?

Is this documented anywhere?

In addition, are the error messages in the following dmesg log anything 
to be concerned about?  They appear during every boot:


[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
fbcon: inteldrmfb (fb0) is primary device
render error detected, EIR: 0x00000010
[drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
render error detected, EIR: 0x00000010
[drm] DAC-5: set mode 1280x1024 16
Console: switching to colour frame buffer device 160x64
fb0: inteldrmfb frame buffer device
registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


Thanks,

Alan Stern

