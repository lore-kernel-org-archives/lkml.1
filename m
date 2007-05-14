Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbXENUya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbXENUya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXENUyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:54:23 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:52880 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752AbXENUyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:54:21 -0400
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070514133745.5bfc34ac.akpm@linux-foundation.org>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	 <46489818.4000408@goop.org>
	 <20070514125946.0f74221c.akpm@linux-foundation.org>
	 <4648C062.5090704@goop.org>
	 <20070514133745.5bfc34ac.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 15:54:18 -0500
Message-Id: <1179176058.3703.85.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 13:37 -0700, Andrew Morton wrote:
> On Mon, 14 May 2007 13:02:42 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Andrew Morton wrote:
> > > Does "that" have name?  I can find no patch in -mm which appears to have
> > > anything to do with SMP consolidation, and this patch applies cleanly to
> > > the current -mm lineup.
> > >   
> > Sorry, I thought you'd picked this up:
> > 
> > 
> > Subject: i386: move common parts of smp into their own file
> > 
> > Several parts of kernel/smp.c and smpboot.c are generally useful for
> > other subarchitectures and paravirt_ops implementations, so make them
> > available for reuse.
> 
> Confused.  This patch conflicts a lot with James's one (which I named
> voyager-fix-build-broken-by-shift-to-smp_ops.patch).

> If your "i386: move common parts of smp into their own file" also fixes
> Voyager and is preferred then cool, but a) the changelog should tell us
> that and b) could James please test it?

OK, let me try a brief history.  A while ago Eric pointed out that the
smp ops patch in -mm would break voyager.  So we worked on (and tested a
fix for it).  Part of the fix was the prerequisite patch "i386: move
common parts of smp into their own file".  The fix on top of this was
called "i386: fix voyager build" which actually fixed the voyager build.

I've been nagging Andi for a couple of weeks now to get these two
upstream.  Finally he replied that the he wasn't planning on sending the
precursor "i386: move common parts of smp into their own file" upstream
for 2.6.22.  So I had to do a patch that would fix the voyager build
without this ... which is what you have.

So, you either need the single patch you have, or the other two entitled

"i386: move common parts of smp into their own file".
"i386: fix voyager build" 

James


