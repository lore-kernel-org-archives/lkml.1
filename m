Return-Path: <linux-kernel-owner+w=401wt.eu-S1946195AbXBCArR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946195AbXBCArR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946196AbXBCArR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:47:17 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59007 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946195AbXBCArQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:47:16 -0500
Date: Sat, 3 Feb 2007 01:47:18 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Berthold Cogel <cogel@rrz.uni-koeln.de>,
       =?utf-8?B?RnJhbsOnb2lz?= Valenduc <francois.valenduc@skynet.be>,
       Alan Stern <stern@rowland.harvard.edu>, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net,
       Prakash Punnoor <prakash@punnoor.de>, Oliver Neukum <oliver@neukum.org>,
       ". Cijoml Cijomlovic Cijomlov" <cijoml@volny.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ttb@tentacle.dhs.org,
       rml@novell.com, Mark Fasheh <mark.fasheh@oracle.com>,
       ocfs2-devel@oss.oracle.com, Eric Van Hensbergen <ericvh@gmail.com>,
       v9fs-developer@lists.sourceforge.net
Subject: 2.6.20-rc7: known regressions (v2) (part 2)
Message-ID: <20070203004718.GK3754@stusta.de>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.20-rc7 compared to 2.6.19
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


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


Subject    : BUG: at fs/inotify.c:172 set_dentry_child_flags()
References : http://bugzilla.kernel.org/show_bug.cgi?id=7785
Submitter  : Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Handled-By : Nick Piggin <nickpiggin@yahoo.com.au>
Status     : problem is being debugged


Subject    : ocfs2_link() journal credits update
References : http://lkml.org/lkml/2007/2/2/171
Submitter  : Mark Fasheh <mark.fasheh@oracle.com>
Caused-By  : Mark Fasheh <mark.fasheh@oracle.com>
             commit 592282cf2eaa33409c6511ddd3f3ecaa57daeaaa
Handled-By : Mark Fasheh <mark.fasheh@oracle.com>
Patch      : http://lkml.org/lkml/2007/2/2/171
Status     : patch available


Subject    : v9fs_vfs_mkdir(): fix a double free
References : http://lkml.org/lkml/2007/2/2/164
Submitter  : Adrian Bunk <bunk@stusta.de>
Caused-By  : Eric Van Hensbergen <ericvh@gmail.com>
             commit da977b2c7eb4d6312f063a7b486f2aad99809710
Handled-By : Adrian Bunk <bunk@stusta.de>
Patch      : http://lkml.org/lkml/2007/2/2/164
Status     : patch available
