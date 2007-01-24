Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbXAXPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbXAXPqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXAXPqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:46:30 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:2025 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751265AbXAXPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:46:29 -0500
Date: Wed, 24 Jan 2007 16:46:34 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, mingo@redhat.com,
       neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org,
       Duncan <1i5t5.duncan@cox.net>, Randy Dunlap <rdunlap@xenotime.net>,
       sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       Berthold Cogel <cogel@rrz.uni-koeln.de>,
       =?utf-8?B?RnJhbsOnb2lz?= Valenduc <francois.valenduc@skynet.be>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       greg@kroah.com, linux-usb-devel@lists.sourceforge.net,
       Prakash Punnoor <prakash@punnoor.de>, Oliver Neukum <oliver@neukum.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: 2.6.20-rc5: known unfixed regressions (v3) (part 1)
Message-ID: <20070124154634.GJ17836@stusta.de>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.20-rc5 compared to 2.6.19
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : raid1: copying a big file triggers OOM killer
References : http://lkml.org/lkml/2007/1/20/69
Submitter  : Justin Piszcz <jpiszcz@lucidpixels.com>
Status     : unknown


Subject    : RAID-6 chunk_aligned_read problem
References : http://bugzilla.kernel.org/show_bug.cgi?id=7835
Submitter  : Duncan <1i5t5.duncan@cox.net>
Status     : unknown


Subject    : ext3 with data=journal hangs when running fsx-linux since -rc2
References : http://bugzilla.kernel.org/show_bug.cgi?id=7844
Submitter  : Randy Dunlap <rdunlap@xenotime.net>
Status     : unknown


Subject    : reboot instead of powerdown  (CONFIG_USB_SUSPEND)
References : http://lkml.org/lkml/2006/12/25/40
             http://bugzilla.kernel.org/show_bug.cgi?id=7828
Submitter  : Berthold Cogel <cogel@rrz.uni-koeln.de>
             François Valenduc <francois.valenduc@skynet.be>
Handled-By : Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Status     : problem is being debugged


Subject    : usb somehow broken  (CONFIG_USB_SUSPEND)
References : http://lkml.org/lkml/2007/1/11/146
Submitter  : Prakash Punnoor <prakash@punnoor.de>
Handled-By : Oliver Neukum <oliver@neukum.org>
             Alan Stern <stern@rowland.harvard.edu>
Status     : problem is being debugged


