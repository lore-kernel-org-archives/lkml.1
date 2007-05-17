Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbXEQR3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbXEQR3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbXEQR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:29:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52352 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754649AbXEQR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:29:09 -0400
Date: Thu, 17 May 2007 10:29:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179385718.27354.17.camel@twins>
Message-ID: <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com>
 <1179385718.27354.17.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Peter Zijlstra wrote:

> I'm really not seeing why you're making such a fuzz about it; normally
> when you push the system this hard we're failing allocations left right
> and center too. Its just that the block IO path has some mempools which
> allow it to write out some (swap) pages and slowly get back to sanity.

I am weirdly confused by these patches. Among other things you told me 
that the performance does not matter since its never (or rarely) being 
used (why do it then?). Then we do these strange swizzles with reserve 
slabs that may contain an indeterminate amount of objects.

