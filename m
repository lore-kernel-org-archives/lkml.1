Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXFBCQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXFBCQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXFBCPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:15:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47031 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786AbXFBCPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:15:54 -0400
Date: Fri, 1 Jun 2007 19:15:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <alpine.DEB.0.99.0706012205080.1305@sigma.j-a-k-j.com>
Message-ID: <Pine.LNX.4.64.0706011914240.11011@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706012205080.1305@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, John Anthony Kazos Jr. wrote:

> > +	 * The behavior for zero sized allocs changes. We no longer
> > +	 * allocate memory but return ZERO_SIZE_PTR.
> > +	 * WARN so that people can review and fix their code.
> 
> I don't see why people have so much opposition to zero-size memory 
> allocations. There's all sorts of situations where you want a resizeable 
> array that may have zero objects, especially in these days of 
> hotpluggability.

In case you have not read the description to the end: This patch does 
exactly what you want and legitimizes zero size object use. The warning 
will be remove before 2.6.22 is released.

