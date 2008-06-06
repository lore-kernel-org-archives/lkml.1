Return-Path: <linux-kernel-owner+w=401wt.eu-S1763506AbYFFHeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506AbYFFHeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbYFFHdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:33:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516AbYFFHdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:33:44 -0400
Date: Fri, 6 Jun 2008 00:33:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606003327.9ac0e91b.akpm@linux-foundation.org>
In-Reply-To: <20080606072536.GA19334@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 09:25:36 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Thu, 5 Jun 2008 17:52:17 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > I have created today's linux-next tree at
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > > 
> > > Instantly oopses on two x86_64 boxes with this config:
> > > http://userweb.kernel.org/~akpm/config-akpm2.txt
> > > 
> > > oops: http://userweb.kernel.org/~akpm/p6056454.jpg
> > >
> > > At a guess I'd say the sched_domains code is calling into slab before 
> > > slab is initalised.  Something like that.
> > 
> > did SLUB change in linux-next? There is no such problem in -tip.
> 
> i just successfully booted your config on 4 separate 64-bit test-systems 
> with latest -tip. (two dual-core boxes, a quad and a 16way box) Latest 
> -tip includes sched-next and x86-next as well.

What's the point in testing a radically differenet kernel from the one
which is known to be crashing?
