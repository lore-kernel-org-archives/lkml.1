Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYHCSpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYHCSpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 14:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYHCSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 14:45:38 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55693 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752270AbYHCSph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 14:45:37 -0400
Date: Sun, 3 Aug 2008 14:45:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bugfixes/cleanups
Message-ID: <20080803184534.GE8402@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1KPShM-0007Ks-M0@closure.thunk.org> <alpine.LFD.1.10.0808031050450.3668@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808031050450.3668@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 10:52:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 2 Aug 2008, Theodore Ts'o wrote:
> > 
> > Please pull from:
> > 
> >         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> Could you please include the expected diffstat too?

Oops, sorry.  Here you go.

 fs/ext4/acl.c     |  188 ++++++++++++++++----------------
 fs/ext4/balloc.c  |   11 +-
 fs/ext4/ext4.h    |    1 -
 fs/ext4/extents.c |   55 ++++++----
 fs/ext4/ialloc.c  |   56 ++++++----
 fs/ext4/inode.c   |  164 +++++++++++++++++++---------
 fs/ext4/mballoc.c |  254 +++++++++++++++++++++++++++++++++++-------
 fs/ext4/mballoc.h |   10 ++-
 fs/ext4/resize.c  |   79 +++++++-------
 fs/ext4/super.c   |  316 ++++++++++++++++++++++++++++-------------------------
 fs/ext4/xattr.c   |    2 +-
 fs/jbd2/commit.c  |   24 ++++-
 fs/jbd2/journal.c |    1 -
 13 files changed, 728 insertions(+), 433 deletions(-)

						- Ted
