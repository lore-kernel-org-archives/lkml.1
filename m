Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYCUTRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYCUTRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYCUTRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:17:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54192 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751381AbYCUTRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:17:32 -0400
Date: Fri, 21 Mar 2008 12:16:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2/2] vmallocinfo: Add caller information
In-Reply-To: <20080321184526.GB6571@elte.hu>
Message-ID: <Pine.LNX.4.64.0803211212520.19558@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com>
 <20080319214227.GA4454@elte.hu> <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com>
 <20080321110008.GW20420@elte.hu> <Pine.LNX.4.64.0803211034140.18671@schroedinger.engr.sgi.com>
 <20080321184526.GB6571@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Ingo Molnar wrote:

> the best i found for lockdep was to include a fair number of them, and 
> to skip the top 3. struct vm_area that vmalloc uses isnt space-critical, 
> so 4-8 entries with a 3 skip would be quite ok. (but can be more than 
> that as well)

STACKTRACE depends on STACKTRACE_SUPPORT which is not available on 
all arches? alpha blackfin ia64 etc are missing it?

I thought there were also issues on x86 with optimizations leading to 
weird stacktraces?


