Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbXJYCn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbXJYCn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXJYCnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:43:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57840 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750916AbXJYCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:43:18 -0400
Date: Wed, 24 Oct 2007 19:43:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Mel Gorman <mel@skynet.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
In-Reply-To: <200710251234.01440.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710241941200.30364@schroedinger.engr.sgi.com>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru>
 <20071024192849.GA3206@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0710241913220.29434@schroedinger.engr.sgi.com>
 <200710251234.01440.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Nick Piggin wrote:

> > Ummm... all unreclaimable is set! Are you mlocking the pages in memory? Or
> > what causes this? All pages under writeback? What is the dirty ratio set
> > to?
> 
> Why is SLUB behaving differently, though.

Nore sure. Are we really sure that this does not occur using SLAB?
 
> Memory efficiency wouldn't be the reason, would it? I mean, SLUB
> should be more efficient than SLAB, plus have less data lying around
> in queues.

SLAB may have data around in queues which (if the stars align the right 
way) may allow it to go longer without having to get a page from the page 
allocator.
