Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbXFBCVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbXFBCVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXFBCVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:21:43 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:42524 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXFBCVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:21:43 -0400
Date: Fri, 1 Jun 2007 22:21:34 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Christoph Lameter <clameter@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <Pine.LNX.4.64.0706011914240.11011@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706012220140.1820@sigma.j-a-k-j.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706012205080.1305@sigma.j-a-k-j.com>
 <Pine.LNX.4.64.0706011914240.11011@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	 * The behavior for zero sized allocs changes. We no longer
> > > +	 * allocate memory but return ZERO_SIZE_PTR.
> > > +	 * WARN so that people can review and fix their code.
> > 
> > I don't see why people have so much opposition to zero-size memory 
> > allocations. There's all sorts of situations where you want a resizeable 
> > array that may have zero objects, especially in these days of 
> > hotpluggability.
> 
> In case you have not read the description to the end: This patch does 
> exactly what you want and legitimizes zero size object use. The warning 
> will be remove before 2.6.22 is released.

Ah, sorry then. I just saw this, and remembered a rather contrary 
discussion about it quite a time ago. Excellent then.
