Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYDCA1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYDCA1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYDCA1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:27:20 -0400
Received: from hs-out-0708.google.com ([64.233.178.249]:22450 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYDCA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=to:subject:content-disposition:organization:date:mime-version:content-type:content-transfer-encoding:message-id:from;
        b=BO8l6cl3DCkdn4pi32mHeJmj+FeJfZqMaZJbAxERoQVX0T8TtlXuFDWn61UON7iUDq3UhxkiPqNjS/FOGJuiifmWUC9184dFyyElJEI+sB2MY/jAe4ApCwr3uIQFQpEiRMRGkollPmbiiNsP64/LMnTpdfexnubAq/VtHIbv24o=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Kernel Mailing List 
	<linux-kernel-owner@vger.kernel.org>,
       Linux Kernel Mailing List <postmaster@vger.kernel.org>
Subject: Re: linux-2.6.25-rc8, an oddity
Content-Disposition: inline
Organization: Organization? Not detectable
Date: Wed, 2 Apr 2008 20:27:11 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804022027.11942.gene.heskett@verizon.net>
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be the third time I've sent this message in about 10 hours, with it 
never making it to the list, but I've picked up around 400 messages since 
because I am subscribed.  Please check as to why I cannot post?

Greetings;

I've switched to an ati based R610 chipset video card, and the radeonhd 
driver, so I can rejoin the canaries that test this stuff.  All brought about 
by my 200GB boot drive giving itself an appendectomy as it was dying of 
whatever they die of when the logs show an incessant attempt to reset the 
drive.  There is now a 500GB on the end of that cable.

3 observations, but I believe only the first is related to this kernel.

1. I note when I logged in (always to runlevel 3, no x at that point) that it 
gave me tty1, instead of the usual tty0.

Is there a reason why the non-x login screen wasn't /dev/tty0?  It does 
exist..

2. Also, if I exit x, expecting to see my original screen, its not there, no 
drive at all to the monitor so it shuts down.  I think I can blindly startx 
again, or type reboot, or give it the vulcan nerve pinch but I don't get 
video back until the reboots post finds it.  This is regardless of the kernel 
running apparently I've tried fedora's latest, 2.6.24.4, and now 2.6.25-rc8.

3. Can I modprobe a vesa related module to fix this somehow?  There are 
several in the /lib/modules/`uname -r`/drivers/video subdir tree but they do 
not show in an lsmod as being loaded.  This card is shown in dmesg only as a 
single entry:

0.526924] pci 0000:02:00.0: Boot video device

and shows as this in lspci -nv now:

02:00.0 0300: 1002:94c4 (prog-if 00 [VGA controller])
        Subsystem: 1545:0028
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 5
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        I/O ports at c000 [size=256]
        Memory at e1000000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] AGP version 3.0

Thanks for any help/info here.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Success is getting what you want; happiness is wanting what you get.
