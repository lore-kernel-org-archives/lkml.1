Return-Path: <linux-kernel-owner+w=401wt.eu-S1161107AbXAZSKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107AbXAZSKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161124AbXAZSKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:10:31 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37049 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161107AbXAZSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:10:29 -0500
Date: Fri, 26 Jan 2007 19:10:36 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, mingo@redhat.com,
       neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, sct@redhat.com,
       adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       Berthold Cogel <cogel@rrz.uni-koeln.de>,
       =?utf-8?B?RnJhbsOnb2lz?= Valenduc <francois.valenduc@skynet.be>,
       Alan Stern <stern@rowland.harvard.edu>, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net,
       Prakash Punnoor <prakash@punnoor.de>, Oliver Neukum <oliver@neukum.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>
Subject: 2.6.20-rc6: known unfixed regressions (part 1)
Message-ID: <20070126181036.GM17836@stusta.de>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.20-rc6 compared to 2.6.19
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : NULL pointer dereference at as_move_to_dispatch()
References : http://lkml.org/lkml/2007/1/22/141
Submitter  : Andrew Vasquez <andrew.vasquez@qlogic.com>
Status     : unknown


Subject    : raid1: copying a big file triggers OOM killer
References : http://lkml.org/lkml/2007/1/20/69
Submitter  : Justin Piszcz <jpiszcz@lucidpixels.com>
Handled-By : Jens Axboe <jens.axboe@oracle.com>
Status     : problem is being debugged


Subject    : ext3 with data=journal hangs when running fsx-linux since -rc2
References : http://bugzilla.kernel.org/show_bug.cgi?id=7844
Submitter  : Randy Dunlap <rdunlap@xenotime.net>
Handled-By : Linus Torvalds <torvalds@linux-foundation.org>
             Randy Dunlap <rdunlap@xenotime.net>
             Andrew Morton <akpm@osdl.org>
Status     : problem is being debugged


Subject    : reboot instead of powerdown  (CONFIG_USB_SUSPEND)
References : http://lkml.org/lkml/2006/12/25/40
             http://bugzilla.kernel.org/show_bug.cgi?id=7828
Submitter  : Berthold Cogel <cogel@rrz.uni-koeln.de>
             François Valenduc <francois.valenduc@skynet.be>
Handled-By : Alan Stern <stern@rowland.harvard.edu>
Status     : problem is being debugged


Subject    : usb somehow broken  (CONFIG_USB_SUSPEND)
References : http://lkml.org/lkml/2007/1/11/146
Submitter  : Prakash Punnoor <prakash@punnoor.de>
Handled-By : Oliver Neukum <oliver@neukum.org>
             Alan Stern <stern@rowland.harvard.edu>
Status     : problem is being debugged


Subject    : fix geode_configure()
References : http://lkml.org/lkml/2007/1/9/216
Submitter  : Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Caused-By  : takada <takada@mbf.nifty.com>
             commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
Handled-By : takada <takada@mbf.nifty.com>
             Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Status     : patches are being discussed



