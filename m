Return-Path: <linux-kernel-owner+w=401wt.eu-S1764728AbYFFIcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764728AbYFFIcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYFFIcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:32:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbYFFIb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:31:59 -0400
Date: Fri, 6 Jun 2008 01:30:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606013058.e5d52c97.akpm@linux-foundation.org>
In-Reply-To: <20080606182206.8bc36f71.sfr@canb.auug.org.au>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
	<20080606175358.a439d1bb.sfr@canb.auug.org.au>
	<20080606010149.4d757b92.akpm@linux-foundation.org>
	<20080606182206.8bc36f71.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:22:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Fri, 6 Jun 2008 01:01:49 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Well yes - I just bodged it by hand then unbodged it later.  But we
> > have a bisection break there.  Admittedly a minor one, unless the bug
> > you're bisecting for requires that kprobes be configured.  But it would
> > be nice to squish it.
> > 
> > I hope Ingo isn't following this
> > once-you've-checked-it-in-you-can't-fix-it stupidity :(
> 
> Its a break caused by the merge of the ftrace tree into the linux-next
> tree (because at the point I merge the ftrace tree, linux-next contains
> the rcu tree which has moves stuff into rculist.h), so logically that
> patch should become part of the merge commit.  If it was part of the
> merge, you could never bisect to a point where you got this build
> breakage.
> 
> Each tree is fine on its own if you go one step back from the merge.

Well OK.  But patches in fact _do_ go into Linux as a single linear
stream of commits.  But the whole git model ignores that reality and
here we see the result.

And saying "git doesn't work like that - you don't understand" just
doesn't cut it.  It is a tool's job to permit humans to implement the
workflow which they wish to follow.  Not to go and force them into
doing something inferior.

Sigh.

/usualrant
