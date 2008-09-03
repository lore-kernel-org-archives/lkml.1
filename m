Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYICLJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYICLJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYICLJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:09:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYICLJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:09:43 -0400
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
From: Peter Zijlstra <peterz@infradead.org>
To: linux@sandersweb.net
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
In-Reply-To: <200809021444.17153.linux@sandersweb.net>
References: <200808311422.12525.linux@sandersweb.net>
	 <200809020808.23131.linux@sandersweb.net>
	 <alpine.LFD.1.10.0809021109330.3210@nehalem.linux-foundation.org>
	 <200809021444.17153.linux@sandersweb.net>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 13:09:39 +0200
Message-Id: <1220440179.8609.100.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 14:44 -0400, David Sanders wrote:
> On Tuesday 02 September 2008 14:12, Linus Torvalds wrote:
> > On Tue, 2 Sep 2008, David Sanders wrote:
> > > I reverted the commit and the problem persits, so nops are definitely not
> > > the problem.  I started an new bisection but am now in a state that won't
> > > compile due to errors.  What do I do in that case?
> >
> > You can try "git bisect skip", but in general the better choice is to just
> > do
> >
> > 	git bisect visualize
> >
> > to open up gitk with the current set of possible targets, and then just
> > pick a likely point by hand, and do
> >
> > 	git reset --hard <sha1-of-the-thing-you-picked>
> >
> > and try that one instead. There's some talk about this in "man git-bisect"
> > but maybe it's not very good.
> >
> > 			Linus
> 
> OK thanks, I had to build a new version of git because the one installed with 
> my distribution was too old to have git bisect skip.  I am trying to use the 
> gitk method you mentioned but it is going slow and on my screen gitk's fonts 
> are very hard to read.

Yeah - gitk's default fonts are a nightmare, I get a semi readable
interface by adding this to ~/.gitk

set mainfont {{dejavu sans mono} 10}
set textfont {{dejavu sans mono} 9}
set uifont {{dejavu sans mono} 10 bold}

But it seems the tcl/tk font rendering is pretty horrible all-round. I
generally prefer to use qgit for this reason.

