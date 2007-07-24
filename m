Return-Path: <linux-kernel-owner+w=401wt.eu-S1765179AbXGXHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765179AbXGXHOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbXGXHOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:14:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57065 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756151AbXGXHOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:14:04 -0400
Date: Tue, 24 Jul 2007 00:14:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
In-Reply-To: <1185259732.8197.30.camel@twins>
Message-ID: <Pine.LNX.4.64.0707240011070.3128@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>  <20070723112143.GB19437@skynet.ie>
 <1185190711.8197.15.camel@twins>  <Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
  <1185256869.8197.27.camel@twins> <1185259732.8197.30.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Peter Zijlstra wrote:

> > Personally I like the consistency of adding __GFP_ZERO here (removes
> > this odd exception) and just masking it in the sl[aou]b thingies.

Adds more code. GFP_LEVEL_MASK are the flags passed through to the 
page allocator. Neither __GFP_ZERO nor __GFP_DMA are passed through and 
therefore they are not part of the GFP_LEVEL_MASK.



