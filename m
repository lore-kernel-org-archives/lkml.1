Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZEPCiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZEPCiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 22:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZEPCiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 22:38:00 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:49857 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbZEPCh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 22:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ULJAFziz+tps5vsjQ6mizwSrsRl7lLu65cPZ6gjj1+LIq0ml7VuWYCG3CDRfgsjJ5Y
         r61UWeT0hoaDatE0llFBmyWacMlpsGnHj3WHUqV8WjAqZw0ULAwdJjlkU7wqlJOpJ3Yi
         OzJSCzx8QlRrw3Rxdtvt3mOqGKrOKFwfmtlyI=
MIME-Version: 1.0
In-Reply-To: <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>
	 <93655eb70905151024o634f8432j6c3db85df1f6ddfc@mail.gmail.com>
	 <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>
Date: Sat, 16 May 2009 08:08:00 +0530
Message-ID: <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Mark Knecht <markknecht@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I presume that if you start your machine and don't start X at all,
> never run Gnome or whatever, that you get similar numbers in your
> console? Possibly the desktop is using a lot of CPU but I doubt it.
> I've never seen that. Every time I've had problems like this it's been
> a newish chipset and the driver for the hard drive interface isn't up
> to snuff yet.
yeah I get similar numbers even in the absence of the desktop manager
, when I tried to copy from  a virtual console.
the stats look something like this :

Linux 2.6.29.1 (satish) 	05/16/2009

08:01:49 AM     CPU     %user     %nice   %system   %iowait    %steal     %idle
08:01:52 AM     all      3.68      0.00      6.72     41.60      0.00     48.00
08:01:55 AM     all      7.10      0.00     15.00     35.81      0.00     42.10
08:01:58 AM     all     10.45      0.00     22.03     51.29      0.00     16.24
08:02:01 AM     all      5.37      0.00      9.12     72.48      0.00     13.03
08:02:04 AM     all      7.25      0.00     12.40     37.04      0.00     43.32
Average:        all      6.77      0.00     13.06     47.58      0.00     32.59


> So, maybe something now about the actual hardware? lspci, lsmod, uname

uname -a :
Linux satish 2.6.29.1 #1 SMP Tue Apr 21 01:17:09 IST 2009 i686 i686
i386 GNU/Linux

lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA IDE Controller (rev 01)
02:06.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
02:06.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
IEEE 1394 Host Controller
02:0e.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)

(sorry , I did not know what to filter out)


> -a. This is your main drive, correct? The driver is built in and not
> modular, or is it a second drive?
does it make a difference if the driver is built in or a module ??




Satish
-- 
http://satish.playdrupal.com
