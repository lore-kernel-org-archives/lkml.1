Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbYBPV7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbYBPV7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 16:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbYBPV7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 16:59:37 -0500
Received: from www.tglx.de ([62.245.132.106]:50842 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYBPV7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 16:59:36 -0500
Date: Sat, 16 Feb 2008 22:59:32 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: What's needed for a PCIe card to be recognized?
Message-ID: <20080216225932.22460d31@dilbert.local>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm playing around with a vanilla 2.6.25-rc1, adding patches to make it
work on an Asus EeePC. That one has the problem that its Mini PCIe WLAN
module doesn't show up in lspci. That brought up a few questions that I
couldn't answer yet:

How can they "hide" a PCIe card?
What could be their motive to do that?
How can I make it appear?

I found some solutions googling around, but they all seem to be funny
workarounds, like unloading pciehp and then loading it again with
pciehp_force=1, then switching WLAN off and on again
(through /proc/acpi/asus/wlan, I've got that one meanwhile)... This
doesn't look like a clean solution to me, but I must admit that I don't
know enough about PCIe hotplug to understand what's going on. I'd
appreciate it if someone could give me a few hints or point me to good
documentation.

Output of lspci:
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to DRAM Controller (rev 04)
00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 04)
00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 04)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 1 (rev 04)
00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 2 (rev 04)
00:1c.2 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 3 (rev 04)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 04)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 04)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 04)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 04)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller (rev 04)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d4)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 04)
00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA Controller (rev 04)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller (rev 04)
03:00.0 Ethernet controller: Attansic Technology Corp. L2 100 Mbit Ethernet Adapter (rev a0)

(The WLAN card should show up at 01:00.0, according to info found on
the web).

Thanks,
Hans


