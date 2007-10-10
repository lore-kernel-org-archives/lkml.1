Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbXJJPF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbXJJPF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbXJJPFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:05:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155AbXJJPFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:05:18 -0400
Date: Wed, 10 Oct 2007 08:04:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: remove zero_page (was Re: -mm merge plans for 2.6.24)
In-Reply-To: <200710100030.28806.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0710100758460.3838@woody.linux-foundation.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0710100424050.24074@blonde.wat.veritas.com>
 <alpine.LFD.0.999.0710092202000.3838@woody.linux-foundation.org>
 <200710100030.28806.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Oct 2007, Nick Piggin wrote:
> 
> It just seems like now might be a good time to just _try_ removing
> the zero page

Yes. Let's do your patch immediately after the x86 merge, and just see if 
anybody screams. 

It might take a while, because I certainly agree that whoever would be 
affected by it is likely to be unusual.

> OK, maybe this is where we are not on the same page.
> There are 2 issues really. Firstly, performance problem of
> refcounting the zero-page -- we've established that it causes
> this livelock and that we should stop refcounting it, right?

Yes, I do agree that refcounting is problematic. 

> Second issue is the performance difference between removing the
> zero page completely, and de-refcounting it (it's obviously
> incorrect to argue for zero page removal for performance reasons
> if the performance improvement is simply coming from avoiding
> the refcounting).

Well, even if it's a "when you don't get into the bad behaviour, 
performance difference is not measurable", and give a before-and-after 
number for some random but interesting load. Even if it's just a kernel 
compile..

		Linus
