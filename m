Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbYIHM31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbYIHM31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYIHM3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:29:19 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:58631 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYIHM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:29:18 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 08:29:18 EDT
Message-ID: <001b01c911ac$f096edc0$0100a8c0@microsof291b50>
From: "Gavin Shan" <gshan@alcatel-lucent.com>
To: <linux-kernel@vger.kernel.org>
Subject: Bogus devices detected from Marvel MV64460
Date: Mon, 8 Sep 2008 20:18:00 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2530
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m88CTVdq032588

Hello, My board is using MV64460 chip and lots of bogus devices were
detected at PCI bus probe time.Those bogus devices has vendor/device
id of 0x648511ab. I don't know why there has so much devices with
vendor/device id of 0x648511ab. Anybody has ideas?

pcibios_init:probe devices for hose 0xc0546800
I/O  0xd0000000-0xd0000fff
MEM0 0x80000000-0x87ffffff
MEM1 0xf2000000-0xf203ffff
MEM2 0xb0000000-0xb0003fff
pci_scan_child_bus: PCI: Scanning bus 0000:00
pci_scan_device: devfn=0, vendor_id=0x648511ab
pci_scan_device: devfn=8, vendor_id=0xffffffff
pci_scan_device: devfn=16, vendor_id=0xffffffff
pci_scan_device: devfn=24, vendor_id=0xffffffff
pci_scan_device: devfn=32, vendor_id=0xffffffff
pci_scan_device: devfn=40, vendor_id=0x648511ab
pci_scan_device: devfn=48, vendor_id=0x648511ab
pci_scan_device: devfn=56, vendor_id=0x648511ab
pci_scan_device: devfn=64, vendor_id=0xcafeb00b
plexus_fixup_mlba: set flags to IORESOURCE_MEM
plexus_fixup_mlba: start 0xb0000000, end=0xb0003fff
pci_scan_device: devfn=72, vendor_id=0x2222b00b
pci_scan_device: devfn=80, vendor_id=0xffffffff
pci_scan_device: devfn=88, vendor_id=0xffffffff
pci_scan_device: devfn=96, vendor_id=0xffffffff
pci_scan_device: devfn=104, vendor_id=0xffffffff
pci_scan_device: devfn=112, vendor_id=0xffffffff
pci_scan_device: devfn=120, vendor_id=0xffffffff
pci_scan_device: devfn=128, vendor_id=0xffffffff
pci_scan_device: devfn=136, vendor_id=0xffffffff
pci_scan_device: devfn=144, vendor_id=0xffffffff
pci_scan_device: devfn=152, vendor_id=0xffffffff
pci_scan_device: devfn=160, vendor_id=0xffffffff
pci_scan_device: devfn=168, vendor_id=0xffffffff
pci_scan_device: devfn=176, vendor_id=0xffffffff
pci_scan_device: devfn=184, vendor_id=0xffffffff
pci_scan_device: devfn=192, vendor_id=0xffffffff
pci_scan_device: devfn=200, vendor_id=0xffffffff
pci_scan_device: devfn=208, vendor_id=0xffffffff
pci_scan_device: devfn=216, vendor_id=0xffffffff
pci_scan_device: devfn=224, vendor_id=0xffffffff
pci_scan_device: devfn=232, vendor_id=0xffffffff
pci_scan_device: devfn=240, vendor_id=0xffffffff
pci_scan_device: devfn=248, vendor_id=0xffffffff
pcibios_init:probe devices for hose 0xc0548000
I/O  0xd1000000-0xd101ffff
MEM0 0x88000000-0x8fffffff
MEM1 0x00000000-0x00000000
MEM2 0x00000000-0x00000000
pci_scan_child_bus: PCI: Scanning bus 0001:00
pci_scan_device: devfn=0, vendor_id=0x648511ab
pci_scan_device: devfn=8, vendor_id=0xffffffff
pci_scan_device: devfn=16, vendor_id=0x06801095
pci_scan_device: devfn=24, vendor_id=0x06801095
pci_scan_device: devfn=32, vendor_id=0xffffffff
pci_scan_device: devfn=40, vendor_id=0xffffffff
pci_scan_device: devfn=48, vendor_id=0xffffffff
pci_scan_device: devfn=56, vendor_id=0xffffffff
pci_scan_device: devfn=64, vendor_id=0xffffffff
pci_scan_device: devfn=72, vendor_id=0xffffffff
pci_scan_device: devfn=80, vendor_id=0xffffffff
pci_scan_device: devfn=88, vendor_id=0x648511ab
pci_scan_device: devfn=96, vendor_id=0x648511ab
pci_scan_device: devfn=104, vendor_id=0x648511ab
pci_scan_device: devfn=112, vendor_id=0xffffffff
pci_scan_device: devfn=120, vendor_id=0xffffffff
pci_scan_device: devfn=128, vendor_id=0xffffffff
pci_scan_device: devfn=136, vendor_id=0xffffffff
pci_scan_device: devfn=144, vendor_id=0xffffffff
pci_scan_device: devfn=152, vendor_id=0xffffffff
pci_scan_device: devfn=160, vendor_id=0xffffffff
pci_scan_device: devfn=168, vendor_id=0xffffffff
pci_scan_device: devfn=176, vendor_id=0xffffffff
pci_scan_device: devfn=184, vendor_id=0xffffffff
pci_scan_device: devfn=192, vendor_id=0xffffffff
pci_scan_device: devfn=200, vendor_id=0xffffffff
pci_scan_device: devfn=208, vendor_id=0xffffffff
pci_scan_device: devfn=216, vendor_id=0xffffffff
pci_scan_device: devfn=224, vendor_id=0xffffffff
pci_scan_device: devfn=232, vendor_id=0xffffffff
pci_scan_device: devfn=240, vendor_id=0xffffffff
pci_scan_device: devfn=248, vendor_id=0xffffffffˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
