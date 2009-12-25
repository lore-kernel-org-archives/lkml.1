Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZLYTaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZLYTaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 14:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZLYTae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 14:30:34 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:53772 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZLYTae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 14:30:34 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: 2.6.33-rc2 odd messages
Date: Fri, 25 Dec 2009 14:29:52 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2; KDE/4.3.3; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <200912251429.52426.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I just built & installed 2.6.33-rc2, and on the reboot, had a long stall
here, which apparently timed out while I was going after my camera:

Dec 25 14:04:47 coyote kernel: [    0.653106] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
Dec 25 14:04:47 coyote kernel: [   60.643402] microcode: failed to load file amd-ucode/microcode_amd.bin
Dec 25 14:04:47 coyote kernel: [   60.643522] microcode: CPU0: patch_level=0x1000065
Dec 25 14:04:47 coyote kernel: [   60.643643] microcode: CPU1: patch_level=0x1000065
Dec 25 14:04:47 coyote kernel: [   60.643768] microcode: CPU2: patch_level=0x1000065
Dec 25 14:04:47 coyote kernel: [   60.643887] microcode: CPU3: patch_level=0x1000065
Dec 25 14:04:47 coyote kernel: [   60.644046] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

However, /lib/firmware/amd-ucode has this file:
[root@coyote amd-ucode]# ls -l
total 4
-rw-r--r-- 1 root root 2012 2009-01-20 04:48 microcode_amd.bin

And, from the looks of the patch_level reported above, it did eventually load 
it, or it was still there since it was a hot reboot, not a full powerdown 
since that's a bit hard on drives.

Is this something in the way of a path that I could pass on the grub kernel 
command line in grub.conf to aid it in finding this file?

Also, quite a bit later (and I have to run blueman-manager and play with it
before a bluetooth 'rfcomm0' link can be re-established that was there
and working fine when I did the reboot logout in x:

Dec 25 14:04:49 coyote bluetoothd[2597]: Failed to access HAL

Any hints on that would be nice too.

Merry Christmas everybody.  And other than the above, 2.6.33-rc2 seems to be 
well, and I note that something has recently taken the glxgears speed up about 
150% on rv610 based cards, thank you for that too.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

	"For I perceive that behind this seemingly unrelated sequence
of events, there lurks a singular, sinister attitude of mind."
	"Whose?"
	"MINE! HA-HA!"
