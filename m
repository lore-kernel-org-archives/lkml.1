Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXBFRwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXBFRwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933153AbXBFRwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:52:10 -0500
Received: from elvira.its.uu.se ([130.238.164.5]:54060 "EHLO elvira.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018AbXBFRwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:52:09 -0500
X-Greylist: delayed 1995 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 12:52:09 EST
Message-ID: <45C8B87E.9090603@lanil.mine.nu>
Date: Tue, 06 Feb 2007 18:18:54 +0100
From: Christian Axelsson <smiler@lanil.mine.nu>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: suspend-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [swsusp] s2ram fails to restore graphics
References: <45C8B688.1080105@lanil.mine.nu>
In-Reply-To: <45C8B688.1080105@lanil.mine.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ups, forgot suspend-devel CC :)

Christian Axelsson wrote:
> Hello!
> 
> I'm having problems with s2ram being unable to restore my Intel 945GM (a 
> Dell D420 laptop) when resuming. I think everything else is restored 
> properly (I have input so I can reboot or suspend again). Full 
> hibernation is working flawless on this machine including restoring 
> framebuffer and X (kudos to the suspend team :).
> 
> I've tried both with and without framebuffer on 2.6.20.
> Using the vbetool-trick brings the backlight on (it's otherwise off 
> after resume).
> 
> .config, lspci and dmesg (prior to suspend) is attached.
> Is there any other info I can provide to assist futher debugging just 
> shout and I will do anything to assist - I would be really happy to get 
> s2ram working :)
> 
> -- 
> Christian Axelsson
> smiler@lanil.mine.nu
> 
> 
> ------------------------------------------------------------------------
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01)
> 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 01)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
> 02:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b4)
> 02:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 09)
> 02:01.2 Class 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 18)
> 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit Ethernet PCI Express (rev 02)
> 0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)

