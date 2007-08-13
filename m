Return-Path: <linux-kernel-owner+w=401wt.eu-S935543AbXHMXEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935543AbXHMXEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbXHMXE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:04:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50253 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753394AbXHMXEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:04:24 -0400
Date: Mon, 13 Aug 2007 16:04:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Phillips <phillips@phunq.net>
cc: Daniel Phillips <daniel.raymond.phillips@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <200708122355.34652.phillips@phunq.net>
Message-ID: <Pine.LNX.4.64.0708131603590.18204@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
 <4a5909270708100115v4ad10c4es697d216edf29b07d@mail.gmail.com>
 <Pine.LNX.4.64.0708101041040.12758@schroedinger.engr.sgi.com>
 <200708122355.34652.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, Daniel Phillips wrote:

> > Because we get to the code of interest when we have no memory on the
> > buddy free lists...
> 
> Ah wait, that statement is incorrect and may well be the crux of your 
> misunderstanding.  Buddy free lists are not exhausted until the entire 
> memalloc reserve has been depleted, which would indicate a kernel bug 
> and imminent system death.

I added the call to reclaim where the memory is out.

