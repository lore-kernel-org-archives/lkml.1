Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbXGXXAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbXGXXAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXGXXAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:00:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47818 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753492AbXGXXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:00:35 -0400
Date: Tue, 24 Jul 2007 16:00:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
In-Reply-To: <20070724151046.d8fbb7da.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707241541310.7288@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins> <20070723112143.GB19437@skynet.ie>
 <1185190711.8197.15.camel@twins> <Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
 <1185256869.8197.27.camel@twins> <Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
 <1185261894.8197.33.camel@twins> <Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
 <20070724120751.401bcbcb@schroedinger.engr.sgi.com>
 <20070724122542.d4ac734a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707241234460.13653@schroedinger.engr.sgi.com>
 <20070724151046.d8fbb7da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Andrew Morton wrote:

> I think I'll duck this for now.  Otherwise I have a suspicion that I'll
> be the first person to run it and I'm too old for such excitement.

I always had the suspicion that you have some magical script 
which will immediately tell you that a patch is not working ;-)

Works fine on x86_64 (on top of the ctor cleanup patchset) and passes the 
kernel build test but then there may be creatively designed drivers and 
such that pass these flags to the slab allocators which will now BUG.
