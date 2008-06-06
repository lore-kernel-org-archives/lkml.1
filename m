Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbYFFHa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbYFFHa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYFFHaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:30:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794AbYFFHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:30:17 -0400
Date: Fri, 6 Jun 2008 00:29:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606002957.6329a0ec.akpm@linux-foundation.org>
In-Reply-To: <20080606071707.GB9708@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 09:17:07 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 5 Jun 2008 17:52:17 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > I have created today's linux-next tree at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > 
> > Instantly oopses on two x86_64 boxes with this config:
> > http://userweb.kernel.org/~akpm/config-akpm2.txt
> > 
> > oops: http://userweb.kernel.org/~akpm/p6056454.jpg
> >
> > At a guess I'd say the sched_domains code is calling into slab before 
> > slab is initalised.  Something like that.
> 
> did SLUB change in linux-next? There no such problem in -tip.

It crashes on two quite different machines with both slab and slub.
