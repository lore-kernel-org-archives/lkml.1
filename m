Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYGPUtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYGPUtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYGPUs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:48:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25626 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYGPUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:48:56 -0400
Date: Wed, 16 Jul 2008 13:43:27 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
	failure
Message-ID: <20080716204327.GB16440@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com> <20080711220740.GC22577@mail.oracle.com> <20080716130821.GF3801@hawkmoon.kerlabs.com> <20080716172703.GA18105@ca-server1.us.oracle.com> <20080716175654.GA19577@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080716175654.GA19577@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 07:56:54PM +0200, Louis Rilling wrote:
> On Wed, Jul 16, 2008 at 10:27:03AM -0700, Joel Becker wrote:
> > On Wed, Jul 16, 2008 at 03:08:21PM +0200, Louis Rilling wrote:
> > > - error handling in config_*_init_type_name(): has rather low priority in my
> > >   TODO list, will come back to it probably in a few weeks.
> > 
> > 	I thought we did this already.  Perhaps I didn't include it?
> > Did we have another change to make?
> 
> You requested me to move a BUG_ON() earlier (before the actual memory
> allocation), and to update documentation. I'm quite in a hurry on other things,
> so I'm delaying this (especially the documentation part for which I feel like a
> new paragraph is needed).

	Sounds good.

> > > - a small locking cleanup in configfs_rmdir(): will do at the same time as
> > >   lockdep stuff.
> > 
> > 	What sort of change?  I suppose I'll see it when it arrives.
> 
> You may look at the retry loop in configfs_rmdir() and see that locks need only
> to be taken inside the loop, not outside. This would result in fewer lines for
> exactly the same behavior.

	I see what you mean.  Not pressing, I agree.

> > 	I figure this new stuff will probably miss the .27 window, but
> > it sounds like that's fine - nothing too serious, and it will make .28.
> 
> Sorry for not being responsive enough. As mentioned above, I have more urgent
> things to work on right now.

	Don't worry, do what you have to do.  We're good for .27 - the
major races have been fixed.  Thank you for all your work!

Joel


-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
