Return-Path: <linux-kernel-owner+w=401wt.eu-S1764708AbYFFIC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764708AbYFFIC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYFFICm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:02:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472AbYFFICj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:02:39 -0400
Date: Fri, 6 Jun 2008 01:01:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606010149.4d757b92.akpm@linux-foundation.org>
In-Reply-To: <20080606175358.a439d1bb.sfr@canb.auug.org.au>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
	<20080606175358.a439d1bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 17:53:58 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Fri, 6 Jun 2008 00:47:43 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > My third bisect iteration has hit this:
> > 
> > arch/x86/mm/kmmio.c: In function 'get_kmmio_probe':
> > arch/x86/mm/kmmio.c:85: error: implicit declaration of function 'list_for_each_entry_rcu'
> 
> You need the following patch from linux-next.  Which should be the commit
> immediately after the merge of the ftrace tree.

Well yes - I just bodged it by hand then unbodged it later.  But we
have a bisection break there.  Admittedly a minor one, unless the bug
you're bisecting for requires that kprobes be configured.  But it would
be nice to squish it.

I hope Ingo isn't following this
once-you've-checked-it-in-you-can't-fix-it stupidity :(

