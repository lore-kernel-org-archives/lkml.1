Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZIIXrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZIIXrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZIIXre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:47:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbZIIXre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:47:34 -0400
Date: Wed, 9 Sep 2009 16:46:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Mackerras <paulus@samba.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31
In-Reply-To: <19112.15202.318732.299671@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.2.01.0909091644550.7458@localhost.localdomain>
References: <alpine.LFD.2.01.0909091529530.7458@localhost.localdomain> <19112.15202.318732.299671@cargo.ozlabs.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Sep 2009, Paul Mackerras wrote:

> Linus Torvalds writes:
> 
> > There's also a fair chunk of new debugging/peformance counter stuff: 
> > memory leak detection ("kmemleak"), memory usage checking ("kmemcheck") 
> > and performance counters ("perf_counter"). Those new debugging features 
> > are not likely usable under any real load, but are good for finding kernel 
> > bugs at a huge performance cost.
> 
> Just to be clear, that last sentence applies to kmemleak and
> kmemcheck, but not perf_counters, right?

Yes. The perfcounter thing is certainly useful under real loads.

But both kmemleak and kmemcheck will probably be pretty unusable if you 
try to do anything that would stress the machine normally. Kind of like 
DEBUG_PAGEALLOC, just much worse.

			Linus
