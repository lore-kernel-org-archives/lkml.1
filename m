Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbXE3PWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbXE3PWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXE3PV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:21:59 -0400
Received: from moci.net4u.de ([217.7.64.195]:55599 "EHLO moci.net4u.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbXE3PV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:21:58 -0400
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 11:21:58 EDT
From: Ernst Herzberg <list-lkml@net4u.de>
Reply-To: earny@net4u.de
Organization: Net4U
To: linux-kernel@vger.kernel.org
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH motherboards.
Date: Wed, 30 May 2007 16:50:48 +0200
User-Agent: KMail/1.9.5
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Robert Hancock <hancockr@shaw.ca>,
       crmotherboard@mailbox.cps.intel.com
References: <fa.4kEpre7NAj1mG6fooUMp/WVc8tg@ifi.uio.no> <465D89E1.7030301@shaw.ca> <Pine.LNX.4.64.0705301029500.13945@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0705301029500.13945@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705301650.50899.list-lkml@net4u.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007 16:33, Justin Piszcz wrote:

> Am I the first person to try using 8 gigabytes of RAM on the 965
> chipset?
>

No. See http://lkml.org/lkml/2007/3/29/222

Same problem on  ASUS P5B-VM with 4GB memory, if "memory remap feature" in
BIOS is activated. Without this option only 2.8GB of memory is avaliable.

lspci:
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 02)
00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port SATA IDE Controller (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc RV515 PRO [Radeon X1300/X1550 Series]
01:00.1 Display controller: ATI Technologies Inc RV515 PRO [Radeon X1300/X1550 Series] (Secondary)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
05:01.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link)
05:03.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless (rev 03)
05:04.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)

<earny>
