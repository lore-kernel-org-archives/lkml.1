Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbYBTP4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbYBTP4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYBTPzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:55:51 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35761 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYBTPzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:55:50 -0500
Date: Wed, 20 Feb 2008 21:26:09 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ak@suse.de, arjan@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL?] Create and populate toplevel tests/ for kernel
	tests
Message-ID: <20080220155609.GC7421@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080211104452.GB7944@in.ibm.com> <20080212164452.GA31096@infradead.org> <20080212132246.aac67ed1.akpm@linux-foundation.org> <20080212223918.GA3927@uranus.ravnborg.org> <20080219192153.GA11948@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219192153.GA11948@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 08:21:53PM +0100, Sam Ravnborg wrote:
> Hi Anath.

Hi Sam,

> Linus did not pull this in the -rc1 to -rc2 timeframe
> so please resubmit the patch serie one week into the
> next merge window (when most of the trees has hit linus' tree
> and Andrew has made his first merge).

Isn't this set a good candidate for linux-next? If so, we could request
Stephen to pull in the patchset.

Ananth

> IF you need an extra eye balling then you can submit
> a few weeks before the merge window opens.
> Thats typical after an -rc with only a few patches.
> 
> Thanks,
> 	Sam
> 
> On Tue, Feb 12, 2008 at 11:39:18PM +0100, Sam Ravnborg wrote:
> > Hi Linus.
> > 
> > Will you consider such a primary code-movement for -rc1
> > or shall we wait until next merge window?
> > 
> > Had we hit -rc2 I would not have sent this pull req and
> > feel free to flame me anyway.
> > 
> > The rationale to get it merged is obviously to avoid
> > merge conflicts and the only reason I ask is that I consider
> > it a low risk patch.
> > 
> > I have not included 8/8 since it was questioned and it
> > will wait until next merge window. But the first 7 was
> > straightforward.
> > 
> > You can pull from:
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/tests.git
> > 
> > diffstat and shortlog below.
> > I also included mail last with a few of the merge related comments.
> > 
> > 	Sam
> > 
> >  Makefile                                        |    1 +
> >  drivers/misc/Makefile                           |    1 -
> >  kernel/Makefile                                 |    4 -
> >  lib/Kconfig.debug                               |   71 +--------------------
> >  lib/Makefile                                    |    1 -
> >  tests/Kconfig                                   |   79 +++++++++++++++++++++++
> >  tests/Makefile                                  |   10 +++
> >  {kernel => tests}/backtracetest.c               |    0 
> >  {drivers/misc => tests}/lkdtm.c                 |   12 ++--
> >  {lib => tests}/locking-selftest-hardirq.h       |    0 
> >  {lib => tests}/locking-selftest-mutex.h         |    0 
> >  {lib => tests}/locking-selftest-rlock-hardirq.h |    0 
> >  {lib => tests}/locking-selftest-rlock-softirq.h |    0 
> >  {lib => tests}/locking-selftest-rlock.h         |    0 
> >  {lib => tests}/locking-selftest-rsem.h          |    0 
> >  {lib => tests}/locking-selftest-softirq.h       |    0 
> >  {lib => tests}/locking-selftest-spin-hardirq.h  |    0 
> >  {lib => tests}/locking-selftest-spin-softirq.h  |    0 
> >  {lib => tests}/locking-selftest-spin.h          |    0 
> >  {lib => tests}/locking-selftest-wlock-hardirq.h |    0 
> >  {lib => tests}/locking-selftest-wlock-softirq.h |    0 
> >  {lib => tests}/locking-selftest-wlock.h         |    0 
> >  {lib => tests}/locking-selftest-wsem.h          |    0 
> >  {lib => tests}/locking-selftest.c               |    0 
> >  {kernel => tests}/rcutorture.c                  |    0 
> >  {kernel => tests}/rtmutex-tester.c              |    2 +-
> >  {kernel => tests}/test_kprobes.c                |    0 
> >  27 files changed, 99 insertions(+), 82 deletions(-)
> > 
> > Ananth N Mavinakayanahalli (7):
> >       Create tests/ directory
> >       Move locking selftests to tests/
> >       Move rcutorture to tests/
> >       Move rtmutex-tests to tests/
> >       Move lkdtm to tests/
> >       Move kprobes smoke tests to tests/
> >       Move backtrace tests to tests/
> > 
> > 
> > 
> > On Tue, Feb 12, 2008 at 01:22:46PM -0800, Andrew Morton wrote:
> > > On Tue, 12 Feb 2008 11:44:52 -0500
> > > Christoph Hellwig <hch@infradead.org> wrote:
> > > 
> > > > On Mon, Feb 11, 2008 at 04:14:52PM +0530, Ananth N Mavinakayanahalli wrote:
> > > > > The following series of patches create and populate the toplevel tests/
> > > > > directory. This will henceforth be the place where all in-kernel tests
> > > > > live.
> > > > > 
> > > > > All patches against 2.6.25-rc1 and are just code movement without any
> > > > > change in functionality.
> > > > 
> > > > ACK to patches 1-7, and I agree with Ingo that the x86-specific test
> > > > should stay under arch/x86.
> > > 
> > > OK.  But now is basically the worst time for me (or anyone else) to merge
> > > large code-motion changes like this, because they need to be carried for
> > > two months or more.
> > > 
> > > And even though git can track renames, putting them into a git tree (say,
> > > git-kbuild) won't help, because if some other git tree tries to modify a
> > > file in its original place, I get to fix up the fallout.
> > > 
> > > Which I _could_ do, and would do if the patches were particularly risky or
> > > added/changed functionality or whatever.  But they don't do that, and there
> > > is little advantage in maintaining them for the >2 months.
> > > 
> > > So.  Please redo and resend the patches when we hit 2.6.25-rc6 or so?
> > > 
> > > Thanks.
> > > 
> > > (linux-next will largely fix all this: git will take care of the renames
> > > and I'll just base the -mm queue on the consolidated linux-next.  But we
> > > aren't there yet).
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
