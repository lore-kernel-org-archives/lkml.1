Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0BBQjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:39:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:30008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0BBQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=pGMGDL9QBFxmDUZSXawdqNIefKAfA2S9pgVfylLGU6+IKXkQTa8cy0IgDvDacji+qc
         oi2+8ItQ7EFxKgQxgsGMjwa5nPeZEHle+Y+p1FH5wsZrGVdOC5Qxi25r4OXMOiqOwcD6
         rcy5wEpW7c6BCT0jTy1F91ykzaLwvyVjpFUBY=
Message-ID: <4B685547.9080003@gmail.com>
Date: Tue, 02 Feb 2010 18:39:35 +0200
From: Georgi Chorbadzhiyski <georgi.chorbadzhiyski@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:467 generic_get_mtrr+0x10c/0x120()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen on HP server when starting X.

------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:467 generic_get_mtrr+0x10c/0x120()
Hardware name: ProLiant ML350 G5
mtrr: your BIOS has set up an incorrect mask, fixing it up.
Modules linked in: ipv6 agpgart lp ppdev parport_pc parport fuse ipmi_si rtc_cmos ipmi_msghandler bnx2 hpilo rtc_core psmouse processor thermal thermal_sys i5k_amb shpchp rtc_lib serio
_raw hwmon sg container evdev button
Pid: 2938, comm: X Not tainted 2.6.32.7 #2
Call Trace:
 [<ffffffff8104adbb>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff8104ae61>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff8101fef0>] ? mtrr_close+0x0/0xb0
 [<ffffffff8102106c>] generic_get_mtrr+0x10c/0x120
 [<ffffffff81020bb5>] mtrr_ioctl+0x625/0x690
 [<ffffffff810f2557>] ? nameidata_to_filp+0x57/0x70
 [<ffffffff81101bba>] ? do_filp_open+0x2ca/0xaf0
 [<ffffffff81147d2f>] proc_reg_unlocked_ioctl+0x6f/0xf0
 [<ffffffff81103422>] vfs_ioctl+0x22/0xa0
 [<ffffffff81103c9d>] do_vfs_ioctl+0x3bd/0x5a0
 [<ffffffff81103f01>] sys_ioctl+0x81/0xa0
 [<ffffffff8100b85b>] system_call_fastpath+0x16/0x1b
---[ end trace c30c8f78147cc1e8 ]---

root@t2:~# lspci
00:00.0 Host bridge: Intel Corporation 5000Z Chipset Memory Controller Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 2-3 (rev b1)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 4 (rev b1)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 5 (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset SATA IDE Controller (rev 09)
01:03.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
01:04.0 System peripheral: Compaq Computer Corporation Integrated Lights Out Controller (rev 03)
01:04.2 System peripheral: Compaq Computer Corporation Integrated Lights Out  Processor (rev 03)
01:04.4 USB Controller: Hewlett-Packard Company Proliant iLO2 virtual USB controller
01:04.6 IPMI SMIC interface: Hewlett-Packard Company Proliant iLO2 virtual UART
02:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
04:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01)
04:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01)
05:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01)
05:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E2 (rev 01)
09:00.0 Multimedia video controller: Blackmagic Design Device a120
0f:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
10:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
12:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev b4)
13:04.0 PCI bridge: Broadcom BCM5785 [HT1000] PCI/PCI-X Bridge (rev b2)
13:08.0 RAID bus controller: Hewlett-Packard Company Smart Array E200i (SAS Controller)

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
