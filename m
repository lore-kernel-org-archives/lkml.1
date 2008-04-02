Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYDBRdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYDBRdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYDBRdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:33:38 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:33754 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYDBRdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=to:subject:content-disposition:organization:date:mime-version:content-type:content-transfer-encoding:message-id:from;
        b=FtyRLcfNOoY1jHH99rhw742IpsWuhXzXvnL6nBTgW4AAUwh7A4iJRZ5B3v94/RxouWNIOJs9A8MYrQeayQmapux12zE4LzCDt0/UNqFccdmhlVI0yV2tnK25mY6MT3deb2JNsNQKz53p+6/LiKBcVXr7g3p7zkf2eWuUOKJ2rPY=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.25-rc8, an oddity
Content-Disposition: inline
Organization: Organization? Not detectable
Date: Wed, 2 Apr 2008 13:33:19 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804021333.20061.gene.heskett@verizon.net>
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
