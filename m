Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbXHUVbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbXHUVbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXHUVbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:31:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53248 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753290AbXHUVa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:30:59 -0400
Date: Tue, 21 Aug 2007 14:30:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
In-Reply-To: <46CB55A8.4030501@redhat.com>
Message-ID: <Pine.LNX.4.64.0708211429530.3390@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com> <46CB01B7.3050201@redhat.com>
 <Pine.LNX.4.64.0708211355430.3082@schroedinger.engr.sgi.com>
 <46CB55A8.4030501@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Rik van Riel wrote:

> > What is preventing that from occurring right now? If the dirty pags are
> > aligned in the right way you can have the exact same situation.
> 
> For one, dirty page writeout is done even when free memory
> is low.  The kernel will dig into the PF_MEMALLOC reserves,
> instead of deciding not to do writeout unless there is lots
> of free memory.

Right that is a fundamental problem with this RFC. We need to be able to 
get into PF_MEMALLOC reserves for writeout.
  
> Secondly, why would you want to recreate this worst case on
> purpose every time the pageout code runs?

I did not intend that to occur.


