Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbXHPUY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbXHPUY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXHPUYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:24:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37713 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbXHPUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:24:19 -0400
Date: Thu, 16 Aug 2007 13:24:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/9] Reclaim during GFP_ATOMIC allocs
In-Reply-To: <20070816024949.GA16372@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0708161322550.17777@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com> <20070816024949.GA16372@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Nick Piggin wrote:

> Just to clarify... I can see how recursive reclaim can prevent memory getting
> eaten up by reclaim (which thus causes allocations from interrupt handlers to
> fail)...
> 
> But this patchset I don't see will do anything to prevent reclaim deadlocks,
> right? (because if there is reclaimable memory at hand, then kswapd should
> eventually reclaim it).

What deadlocks are you thinking about? Reclaim can be run concurrently 
right now.


