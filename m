Return-Path: <linux-kernel-owner+w=401wt.eu-S935851AbYEVJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935851AbYEVJAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYEVJAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:00:35 -0400
Received: from ozlabs.org ([203.10.76.45]:38495 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbYEVJAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:00:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] Introduce down_nowait()
Date: Thu, 22 May 2008 18:56:23 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
References: <200805211600.16415.rusty@rustcorp.com.au> <200805211756.04731.rusty@rustcorp.com.au> <1211389499.18130.53.camel@localhost.localdomain>
In-Reply-To: <1211389499.18130.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221856.23824.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008 03:04:58 Daniel Walker wrote:
> On Wed, 2008-05-21 at 17:56 +1000, Rusty Russell wrote:
> > Subject: [PATCH] Introduce down_try()
> >
> > I planned on removing the much-disliked down_trylock() (with its
> > backwards return codes) in 2.6.27, but it's creating something of a
> > logjam with other patches in -mm and linux-next.
> >
> > Andrew suggested introducing "down_try" as a wrapper now, to make
> > the transition easier.
>
> I must be missing something critical, but what's the logjam this is
> causing?
>
> Daniel

The patches to change down_trylock to down_try touch a heap of files, which 
are also touched in other people's trees.  If this patch goes upstream, those 
people rewriting that code can use down_try in their rewrite, and I can throw 
mine away.

Cheers,
Rusty.
