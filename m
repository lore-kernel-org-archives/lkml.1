Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYFFJBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYFFJBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYFFJBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:01:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbYFFJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:01:43 -0400
Date: Fri, 6 Jun 2008 02:01:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606020109.c0db7a0c.akpm@linux-foundation.org>
In-Reply-To: <20080606084949.GA28190@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
	<20080606082325.GA10826@elte.hu>
	<20080606013835.8dfd838b.akpm@linux-foundation.org>
	<20080606084949.GA28190@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 10:49:49 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > most of the -tip topics (there are 75 of them currently) are present 
> > > in linux-next - about ~70% of all -tip commits are in linux-next 
> > > already. The stuff that is not in linux-next yet is either because 
> > > it's: miscellany fixes (i.e. intentionally grabbed out-of-tree to 
> > > make our tests work better), not cooked enough yet, or because we 
> > > are still working it out - tip is less than a month old still.
> > > 
> > > in general the rule is that if there's anything we want to push 
> > > upstream, it will show up in linux-next.
> > 
> > I don't think it's a good idea for you guys to be off working on 
> > 2.6.28 material when we're trying to stabilise 2.6.25, 2.6.26 and 
> > preparing for 2.6.27.
> > 
> > What's especially regrettable is that, afaik, you are expending 
> > testing resources on a tree which nobody will ever run rather than 
> > upon the tree which everyone _will_ run :( [...]
> 
> what do you mean? We are testing commits that everybody will run and are 
> pre-filtering them for sanity and stability before they hit linux-next.
> 

One doesn't test commits - one tests a tree.  And the -tip tree is
2.6.26-rc5 plus a bunch of x86 changes.  That tree will never be run by
anyone.  Testing -tip fails to pick up problems which are caused by
integration of the x86 changes with everyone else's work and it fails
to pick up problems which lie wholly outside the x86 changes.

For both these reasons it would be more valuable were that testing
effort to be expended on our 2.6.27 candidate tree.

Plus, of course, there's the risk that linux-next contains x86-only
regressions which were fixed or avoided in -tip.




Bisecting: 5 revisions left to test after this
[29657a44f8660acd8751d7e9f5aac06ec8633481] x86: cleanup early per cpu variables/accesses v4

