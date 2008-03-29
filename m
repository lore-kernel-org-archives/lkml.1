Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYC2F0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYC2F0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 01:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYC2F0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 01:26:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbYC2F0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 01:26:08 -0400
Date: Fri, 28 Mar 2008 22:25:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd/jbd2 NULL noise
Message-Id: <20080328222559.96fb9691.akpm@linux-foundation.org>
In-Reply-To: <20080329031843.GJ10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
	<1206760526.6543.0.camel@brick>
	<20080329031843.GJ10722@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008 03:18:43 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Mar 28, 2008 at 08:15:26PM -0700, Harvey Harrison wrote:
> > On Sat, 2008-03-29 at 03:07 +0000, Al Viro wrote:
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > ---
> > >  fs/jbd/journal.c  |    4 ++--
> > >  fs/jbd/revoke.c   |    4 ++--
> > >  fs/jbd2/journal.c |   12 ++++++------
> > >  fs/jbd2/revoke.c  |    4 ++--
> > >  4 files changed, 12 insertions(+), 12 deletions(-)
> > > 
> > 
> > I had just about all of fs/ done for this sitting in mm.
> 
> So send it?  I mean, that hardly has a potential to cause breakage - anything
> wrong will be immediately seen on build.

Still, it didn't meet my (and apparently Ted's) is-it-needed-in-late-rc
criteria.

>From a later email:

> You've really got me curious.  The latest -mm I can find is 2.6.25-rc5-mm1,
> it's dated Mar 11 and the patches are very much there -
> broken-out/jbd-sparse-warnings-in-revokec-journalc.patch and
> broken-out/jbd2-sparse-warnings-in-revokec-journalc.patch
> resp., all by themselves and not as a part of any subsystem tree.

The jbd2 one went into the ext4 tree.

Alas, -mm's are slow nowadays.  Due to a combination of a) the difficulty
of getting it all to compile, let alone boot on sevenish machines, and b)
waning motivation due to me wondering why we merge so much new stuff when
we've just written so many bugs.

My tree is always available at http://userweb.kernel.org/~akpm/mmotm/ -
it's updated multiple times per day.

> 
> Al, still morbidly curious about the akpm's scripts and aforementioned
> message...

The jbd2 changes got moved into the ext4 tree at
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/
hence I dropped them from the mm-specific patches.  I still have the patch,
but it's now known as
ext4-mm-jbd2-sparse-warnings-in-revokec-journalc.patch because Ted now owns
it.  

> Linus, consider the patch upthread withdrawn.

Whatever.  As long as it got merged.
