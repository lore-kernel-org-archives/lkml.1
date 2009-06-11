Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbZFKJwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbZFKJwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbZFKJvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:51:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34677 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbZFKJvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:51:44 -0400
Subject: Re: [PATCH 1/2] SLUB: Out-of-memory diagnostics
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       Larry.Finger@lwfinger.net
In-Reply-To: <20090611094728.GA7302@csn.ul.ie>
References: <Pine.LNX.4.64.0906111142350.6132@melkki.cs.Helsinki.FI>
	 <20090611094728.GA7302@csn.ul.ie>
Date: Thu, 11 Jun 2009 12:51:44 +0300
Message-Id: <1244713904.17483.21.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Thu, 2009-06-11 at 10:47 +0100, Mel Gorman wrote:
> On Thu, Jun 11, 2009 at 11:43:46AM +0300, Pekka J Enberg wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > As suggested by Mel Gorman, add out-of-memory diagnostics to the SLUB allocator
> > to make debugging OOM conditions easier.
> 
> Picky - make debugging page allocation failures easier. OOM in this
> context might be conflated with the OOM-killer.
> 
> > This patch helped hunt down a nasty
> > OOM issue that popped up every now that was caused by SLUB debugging code which
> > forced 4096 byte allocations to use order 1 pages even in the fallback case.
> > 
> > An example print out looks like this:
> > 
> >   <snip page allocator out-of-memory message>
> >   SLUB: Unable to allocate memory on node -1 (gfp=20)
> 
> node -1 is an implementation detail. Can it print "current" instead? No
> biggie, I know what it means and I suppose anyone debugging an allocation
> failure will know too.

I'd rather keep it as-is because as you say anyone debugging an
allocation failure will know what it means.

On Thu, 2009-06-11 at 10:47 +0100, Mel Gorman wrote:
> gfp is in hex right so gfp=0x20? gfp=20 might have someone thinking it's
> the decimal value.

Fixed. Thanks!

			Pekka

