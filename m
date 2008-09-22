Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYIVU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYIVU2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYIVU2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:28:11 -0400
Received: from eazy.amigager.de ([213.239.192.238]:39844 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYIVU2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:28:10 -0400
Date: Mon, 22 Sep 2008 22:29:11 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Wakeup from suspend via keyboard and mouse doesn't work anymore
	with 2.6.27-rc
Message-ID: <20080922202911.GA9832@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my Mac mini core duo used to wake up from suspend to RAM when a key or
mouse button is pressed. This doesn't work anymore with 2.6.27-rc, the
current version that I tried is 2.6.27-rc7. I checked /proc/acpi/wakeup
for differences, with 2.6.26 and 2.6.27-rc, but both were identical:

Device	S-state	  Status   Sysfs node
PXS1	  S4	 disabled  pci:0000:01:00.0
PXS2	  S4	 disabled  pci:0000:02:00.0
USB1	  S3	 disabled  pci:0000:00:1d.0
USB2	  S3	 disabled  pci:0000:00:1d.1
USB3	  S3	 disabled  pci:0000:00:1d.2
USB4	  S3	 disabled  pci:0000:00:1d.3
USB7	  S3	 enabled   pci:0000:00:1d.7

Wakeup with the power switch at the back still works.

Any hints if there are some commits that I should try to revert, before
I start bisecting?

Regards,
Tino
