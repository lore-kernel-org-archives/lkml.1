Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXFNMhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXFNMhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFNMha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:37:30 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:49556 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXFNMh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:37:29 -0400
Date: Thu, 14 Jun 2007 08:37:11 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: floppy1?
To: linux-kernel@vger.kernel.org
Message-id: <200706140837.11483.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings folks;

Kernel is 2.6.22-rc4, no other patches.

dmesg seems to be being spammed by variations of the following theme, 
variations because it could and has said floppy0 also.

floppy1: floppy timeout called
end_request: I/O error, dev fd1, sector 0
Buffer I/O error on device fd1, logical block 0

floppy driver state
-------------------
now=523329925 last interrupt=523326926 diff=2999 last called handler=f9a2e2ef
timeout_message=floppy start
last output bytes:
 0 90 523326925
13 90 523326925
 0 90 523326925
1a 90 523326925
 0 90 523326925
 3 90 523326925
c1 90 523326925
 8 90 523326925
 7 90 523326925
 1 90 523326925
 8 82 523326926
e6 80 523326926
 1 90 523326926
 0 90 523326926
 0 90 523326926
 1 90 523326926
 2 90 523326926
 9 90 523326927
2a 90 523326927
ff 90 523326927
last result at 523326926
last redo_fd_request at 523326925
21  0
status=50
fdc_busy=1
do_floppy=f9a29331
fd_timer.function=f9a2b1aa
cont=f9a325cc
current_req=d24fa0b0
command_status=-1

floppy1: floppy timeout called
end_request: I/O error, dev fd1, sector 0

There is not, and has not been for weeks, a disk in either drive, floppy1 
being a 5.25" drive I use for legacy sneakernet stuffs.  However I see these 
messages intermittently now for the last several kernel builds, reaching back 
to the 2.6.21 time frame IIRC.

Is this something that should be looked at?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Every morning, I get up and look through the 'Forbes' list of the
richest people in America.  If I'm not there, I go to work"
		-- Robert Orben
