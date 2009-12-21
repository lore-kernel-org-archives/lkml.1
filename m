Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZLUIQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZLUIQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 03:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZLUIQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 03:16:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:47106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZLUIQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 03:16:46 -0500
Message-ID: <4B2F2F83.4070901@kernel.org>
Date: Mon, 21 Dec 2009 17:19:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to dynamically
 allocate counters
References: <20091218222617.384355422@quilx.com> <20091218222651.319887863@quilx.com> <4B2F2820.5030904@kernel.org> <4B2F2AE8.7060507@kernel.org>
In-Reply-To: <4B2F2AE8.7060507@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 04:59 PM, Tejun Heo wrote:
> Here's the version I committed to percpu branch.
> 
> Thanks.
> 
> From 8af47ddd01364ae3c663c0bc92415c06fe887ba1 Mon Sep 17 00:00:00 2001
> From: Christoph Lameter <cl@linux-foundation.org>
> Date: Fri, 18 Dec 2009 16:26:24 -0600
> Subject: [PATCH] module: Use this_cpu_xx to dynamically allocate counters
> 
> Use cpu ops to deal with the per cpu data instead of a local_t. Reduces memory
> requirements, cache footprint and decreases cycle counts.
> 
> The this_cpu_xx operations are also used for !SMP mode. Otherwise we could
> not drop the use of __module_ref_addr() which would make per cpu data handling
> complicated. this_cpu_xx operations have their own fallback for !SMP.
> 
> The last hold out of users of local_t is the tracing ringbuffer after this patch
> has been applied.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

This was changed to Acked-by as Rusty acked on the previous thread.

Thanks.

-- 
tejun
