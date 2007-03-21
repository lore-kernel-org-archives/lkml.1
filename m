Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXCUOlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXCUOlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbXCUOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:41:11 -0400
Received: from mx2.go2.pl ([193.17.41.42]:49086 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752904AbXCUOlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:41:10 -0400
Date: Wed, 21 Mar 2007 15:45:39 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast\@domdv\.de" <ast@domdv.de>,
       "linux-kernel\@vger\.kernel\.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070321144539.GD1939@ff.dom.local>
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI> <20070321101143.GB1939@ff.dom.local> <84144f020703210513i37d1576erb7814483bcaad505@mail.gmail.com> <20070321133151.GC1939@ff.dom.local> <Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 03:36:34PM +0200, Pekka J Enberg wrote:
> On Wed, 21 Mar 2007, Jarek Poplawski wrote:
> > With  __kmem_cache_free you would set #1 I hope, but if
> > nobody would use this - debugging time wouldn't change.
> 
> I think you got it backwards. I suggested making the _current_ 
> kmem_cache_free() deal with NULL (so everyone will get it) and add a new 
> optimized __kmem_cache_free() for those call-sites that really need it.

If you could assure optimized version will be used only with
buggy-free code, so you don't waste time for debugging it,
then I really got it backwards, sorry!

> 
> On Wed, 21 Mar 2007, Jarek Poplawski wrote:
> > This could be acceptable, if there were no problems
> > with fixing the errors. But there are problems - bugs
> > like this aren't fixed on time - maybe because people
> > waste too much time per bug?
> 
> You're barking up the wrong tree here, Jarek. I strongly feel that we 
> should be more defensive in the slab for the exact reasons you outlined. 
> There's bunch of bug reports people seem to dismiss as slab errors where 
> in fact it's caused by a buggy caller.

But I can see only one tree here. And I seem to agree with all the rest.
So, I probably really got it backwards...

Must be going to find the right tree,
Jarek P.
