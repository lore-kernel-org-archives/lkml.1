Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYGPR13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYGPR13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYGPR1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:27:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52499 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYGPR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:27:17 -0400
Date: Wed, 16 Jul 2008 10:27:03 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
	failure
Message-ID: <20080716172703.GA18105@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com> <20080711220740.GC22577@mail.oracle.com> <20080716130821.GF3801@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716130821.GF3801@hawkmoon.kerlabs.com>
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

On Wed, Jul 16, 2008 at 03:08:21PM +0200, Louis Rilling wrote:
> On Fri, Jul 11, 2008 at 03:07:40PM -0700, Joel Becker wrote:
> > On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
> > > This patchset fixes two kinds of bugs happening when
> > > configfs_attach_group()/configfs_attach_item() fail and userspace races with
> > > mkdir() or symlink().
> > 
> > 	Ok, I've merged all this work.  Please check out my configfs-ALL
> > branch and make sure I have everything we've worked on.
> > 
> > http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=configfs-ALL
> > git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL
> 
> Looks complete.

	Ok, I'm going to get it to linux-next,then off to Linus for .27.

> There is still a few things in flight:
> - error handling in config_*_init_type_name(): has rather low priority in my
>   TODO list, will come back to it probably in a few weeks.

	I thought we did this already.  Perhaps I didn't include it?
Did we have another change to make?

> - a small locking cleanup in configfs_rmdir(): will do at the same time as
>   lockdep stuff.

	What sort of change?  I suppose I'll see it when it arrives.
	I figure this new stuff will probably miss the .27 window, but
it sounds like that's fine - nothing too serious, and it will make .28.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
