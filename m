Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbXFDTBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbXFDTBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXFDTA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:00:59 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53614 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758349AbXFDTA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:00:58 -0400
Date: Mon, 4 Jun 2007 21:01:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070604190102.GY5500@stusta.de>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530140227.070136408@polymtl.ca>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:00:26AM -0400, Mathieu Desnoyers wrote:
> Conditional calls are used to compile in code that is meant to be dynamically
> enabled at runtime. When code is disabled, it has a very small footprint.
> 
> It has a generic cond_call version and optimized per architecture cond_calls.
> The optimized cond_call uses a load immediate to remove a data cache hit.
> 
> It adds a new rodata section "__cond_call" to place the pointers to the enable
> value.
>...

I have two questions for getting the bigger picture:

1. How much code will be changed?
Looking at the F00F bug fixup example, it seems we'll have to make
several functions in every single driver conditional in the kernel for 
getting the best performance.
How many functions to you plan to make conditional this way?

2. What is the real-life performance improvement?
That micro benchmarks comparing cache hits with cache misses give great 
looking numbers is obvious.
But what will be the performance improvement in real workloads after the
functions you plan to make conditional according to question 1 have been 
made conditional?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

