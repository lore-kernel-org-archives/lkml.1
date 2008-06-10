Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYFJOnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYFJOnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbYFJOm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:42:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbYFJOm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:42:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
References: <patchbomb.1212814533@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Jun 2008 10:41:45 -0400
In-Reply-To: <patchbomb.1212814533@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Sat, 07 Jun 2008 00:55:33 -0400")
Message-ID: <x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> Another post of my block I/O data integrity patches.  This kit goes on
> top of the scsi_data_buffer and sd.h cleanups I posted earlier today.

Pointers to archives would have been appreciated.  I can't, for the life
of me, find these.

> There has been no changes to the block layer code since my last
> submission.
>
> Within SCSI, the changes are cleanups based on comments from Christoph
> as well as working support for Type 3 and 4KB sectors.

Thanks for all of the great documentation.  It would be good to include
some instructions on how one would test this, and what testing you
performed.  Also, please use the '-p' switch to diff, as it makes
reviewing patches much easier.

I set out to try your changes, but ran into some problems.  First, this
patch set didn't apply cleanly to a git checkout.  So, I grabbed your
mercurial repository, but got a build failure:

block/blk-core.c: In function 'generic_make_request':
include/linux/bio.h:469: sorry, unimplemented: inlining failed in call to 'bio_i
ntegrity_enabled': function body not available
block/blk-core.c:1388: sorry, unimplemented: called from here
make[1]: *** [block/blk-core.o] Error 1
make: *** [block] Error 2

Cheers,

Jeff
