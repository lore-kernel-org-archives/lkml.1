Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXCGG7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXCGG7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbXCGG7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:59:37 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:56688 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbXCGG7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:59:36 -0500
Date: Wed, 07 Mar 2007 01:59:27 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Unused floppy1 going bonkers in 2.6.20-rds
To: linux-kernel@vger.kernel.org
Message-id: <200703070159.28742.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Kernel 2.6.20-rds (Cons patch), biostar mobo. 1GB of memory.

I have an elderly 5.25" floppy drive mounted in this box, something I use 
for sneakernet duties to get to a 'legacy' machine occasionally.  It 
hasn't been used for anything in about a month or more.  No disk in it 
now.

Uptime 0d:15:47

The messages file is being cluttered with this:

Mar  7 01:17:22 coyote kernel:
Mar  7 01:17:22 coyote kernel: floppy driver state
Mar  7 01:17:22 coyote kernel: -------------------
Mar  7 01:17:22 coyote kernel: now=54902555 last interrupt=54899556 
diff=2999 last called handler=f89f833f
Mar  7 01:17:22 coyote kernel: timeout_message=floppy start
Mar  7 01:17:22 coyote kernel: last output bytes:
Mar  7 01:17:22 coyote kernel:  0 90 54899555
Mar  7 01:17:22 coyote kernel: 13 90 54899555
Mar  7 01:17:22 coyote kernel:  0 90 54899555
Mar  7 01:17:22 coyote kernel: 1a 90 54899555
Mar  7 01:17:22 coyote kernel:  0 90 54899555
Mar  7 01:17:22 coyote kernel:  3 90 54899555
Mar  7 01:17:22 coyote kernel: c1 90 54899555
Mar  7 01:17:22 coyote kernel:  8 90 54899555
Mar  7 01:17:22 coyote kernel:  7 80 54899555
Mar  7 01:17:22 coyote kernel:  1 90 54899556
Mar  7 01:17:22 coyote kernel:  8 82 54899556
Mar  7 01:17:22 coyote kernel: e6 80 54899556
Mar  7 01:17:22 coyote kernel:  1 90 54899556
Mar  7 01:17:22 coyote kernel:  0 90 54899556
Mar  7 01:17:22 coyote kernel:  0 90 54899556
Mar  7 01:17:22 coyote kernel:  1 90 54899556
Mar  7 01:17:22 coyote kernel:  2 90 54899556
Mar  7 01:17:22 coyote kernel:  9 90 54899556
Mar  7 01:17:22 coyote kernel: 2a 90 54899556
Mar  7 01:17:22 coyote kernel: ff 90 54899556
Mar  7 01:17:22 coyote kernel: last result at 54899556
Mar  7 01:17:22 coyote kernel: last redo_fd_request at 54899555
Mar  7 01:17:22 coyote kernel: 21  0
Mar  7 01:17:22 coyote kernel: status=50
Mar  7 01:17:22 coyote kernel: fdc_busy=1
Mar  7 01:17:22 coyote kernel: do_floppy=f89f3323
Mar  7 01:17:22 coyote kernel: fd_timer.function=f89f51b2
Mar  7 01:17:22 coyote kernel: cont=f89fc5ec
Mar  7 01:17:22 coyote kernel: current_req=e8eaa9c8
Mar  7 01:17:22 coyote kernel: command_status=-1
Mar  7 01:17:22 coyote kernel:
Mar  7 01:17:22 coyote kernel: floppy1: floppy timeout called
Mar  7 01:17:22 coyote kernel: end_request: I/O error, dev fd1, sector 0
Mar  7 01:17:22 coyote kernel: Buffer I/O error on device fd1, logical 
block 0

About 8 or 9 times since it was rebooted 16 hours ago, and very 
intermittent, it might skip 3 hours, then show two of these stanza's in 3 
seconds.

The drive type is properly set in the bios if that actually means 
anything.

The only mention of floppy in /var/log/dmesg is the ide-floppy driver 
signing in during the boot cause I've got one of those 100MB floppies I 
occasionally use too.  It is not installed at the moment.

Has anyone else seen this in a box with two floppy drives in it?

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Function reject.
