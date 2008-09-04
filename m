Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYIDFG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYIDFG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 01:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYIDFGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 01:06:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbYIDFGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 01:06:19 -0400
Date: Wed, 3 Sep 2008 22:05:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080903220546.bd673658.akpm@linux-foundation.org>
In-Reply-To: <20080904145744.3f791ca7.sfr@canb.auug.org.au>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<20080903215455.792c78a3.akpm@linux-foundation.org>
	<20080904145744.3f791ca7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 14:57:44 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 3 Sep 2008 21:54:55 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 3 Sep 2008 21:46:34 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > >  Apart from the lack of any
> > > login prompt on the console (sshd works), but I suspect that was a
> > > separate gift.
> > 
> > And the very first damn bisection point goes:
> > 
> > In file included from include/asm/statfs.h:11,
> >                  from include/linux/statfs.h:6,
> >                  from include/linux/vfs.h:4,
> >                  from fs/open.c:22:
> > include/asm-generic/statfs.h:20: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__u32'
> > 
> > and that bisection breakage is going to get trotted into mainline
> > for evermore.
> 
> No it isn't because it came from dwmw2's tree and that has already been
> rewritten/rebased ...

Thank gawd for that.

This breakage spans over 1000 commits.  Not sure how that can happen in
a rebased tree, but whatever.

