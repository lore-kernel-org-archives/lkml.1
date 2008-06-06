Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbYFFIjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbYFFIjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYFFIjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:39:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbYFFIjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:39:05 -0400
Date: Fri, 6 Jun 2008 01:38:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606013835.8dfd838b.akpm@linux-foundation.org>
In-Reply-To: <20080606082325.GA10826@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
	<20080606082325.GA10826@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 10:23:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > > i just successfully booted your config on 4 separate 64-bit 
> > > > > test-systems with latest -tip. (two dual-core boxes, a quad and a 
> > > > > 16way box) Latest -tip includes sched-next and x86-next as well.
> > > > 
> > > > What's the point in testing a radically differenet kernel from the one 
> > > > which is known to be crashing?
> > > 
> > > well, you Cc:-ed me, so i wanted to exclude -tip's 750+ commits in this 
> > > area (scheduling, 64-bit x86) in the first step.
> > 
> > What's the relationship between -tip and linux-next?
> 
> most of the -tip topics (there are 75 of them currently) are present in 
> linux-next - about ~70% of all -tip commits are in linux-next already. 
> The stuff that is not in linux-next yet is either because it's: 
> miscellany fixes (i.e. intentionally grabbed out-of-tree to make our 
> tests work better), not cooked enough yet, or because we are still 
> working it out - tip is less than a month old still.
> 
> in general the rule is that if there's anything we want to push 
> upstream, it will show up in linux-next.

I don't think it's a good idea for you guys to be off working on 2.6.28
material when we're trying to stabilise 2.6.25, 2.6.26 and preparing
for 2.6.27.

What's especially regrettable is that, afaik, you are expending testing
resources on a tree which nobody will ever run rather than upon the
tree which everyone _will_ run :(  We'd all be better off if that testing
was being performed against linux-next.  Or at least some (most) of it.


ho hum.

Bisecting: 23 revisions left to test after this
[919b0a2702e5a0284094f63215da65539f6ef692] Merge branch 'x86/ptemask' into auto-x86-next

No -mm today...
