Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbXFDQQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbXFDQQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXFDQQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:16:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53736 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755845AbXFDQQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:16:40 -0400
Date: Mon, 4 Jun 2007 09:16:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> 
 <20070601204141.f84ad72f.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> 
 <20070601213117.1178e8e0.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Pekka Enberg wrote:

> On Fri, 1 Jun 2007, Andrew Morton wrote:
> > > They are different instances which happen to have the same length (zero).
> 
> On 6/2/07, Christoph Lameter <clameter@sgi.com> wrote:
> > I guess one could use the slab allocators as a type of reservation
> > ticket generator with zero sized objects. Hmmm.... But is that really a
> > useful thing to do?
> 
> Can someone remind me why we can't do what mm/slab.c does for
> zero-size allocations in slub too?

We are doing that right now. The problem is that people keep storing stuff 
in memory allocated with kmalloc(0).
 
