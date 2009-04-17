Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbZDQXAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbZDQXAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZDQXAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:00:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53349 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbZDQW77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:59:59 -0400
Message-ID: <49E909E7.3070709@pobox.com>
Date: Fri, 17 Apr 2009 18:59:51 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Mark Lord <liml@rtr.ca>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: libata git repo guide (was Re: [PATCH 01/02] sata_mv: tidy up qc->tf
 usage in qc_prep() functions)
References: <49E359D6.1090309@rtr.ca>
In-Reply-To: <49E359D6.1090309@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> For upstream-linus, please.


Any volunteers wanna format and post this to the wiki? 
http://ata.wiki.kernel.org/

For what it's worth, upstream-linus is for Linus only, not for anyone else.

Relevant branches of libata-dev.git:

ALL		All libata code I consider acceptable for public
		testing.  Intended for Andrew Morton's -mm tree,
		but I am always looking for people to help test!

NEXT		libata code intended for current kernel + 1
		This is a subset of ALL, and is intended for
		the linux-next tree, and even more rigorous
		public testing.

upstream-fixes	This branch exists when the merge window is NOT open.
		Fixes queued for Linus go here, during -rc.  Generally
		I push to Linus pretty rapidly, though, so programmers
		are encouraged to send patches diff'd against Linus
		upstream during -rc.

upstream	libata code intended for current kernel + 1.  When the
		merge window is closed, patches are queued here.  When
		the merge window is open, fixes for Linus are also
		queued here.

		Generally upstream==NEXT, but this is not guaranteed.

		i.e. sometimes I will put a fix on a separate git
		branch, and then merge that into the mix, such that

			NEXT == upstream + fix-that-needs-testing

And then there are individual branches that pop in and out of existence, 
as I do my own work.  For example, currently active branches are

fixes-eh-freeze	  Freeze ordering fix recently discussed; needs some
		codepath review before I am sure it is safe. (NEXT)

libahci		libahci patchset recently posted (NEXT, ALL)

sectsize	Variable sector size patch.  Will not go into
		#upstream branch until I satisfy some request of
		willy's, which slips my mind at the moment (ALL)

sx4		sata_sx4 new EH conversion (ALL)

And last, but not least,

master		Vanilla Linux kernel, with no changes from me.

		Exists to indicate the root of all above branches,
		so that "git log master..libahci" or
		"git diff master..upstream" works as expected.


NOTE:  All of the branches except 'master' may be rebased.


