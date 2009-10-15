Return-Path: <linux-kernel-owner+w=401wt.eu-S1762249AbZJOIKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762249AbZJOIKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761744AbZJOIKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:10:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53410 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761676AbZJOIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:10:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=O5gGnFsAJCza15HXMcerj5z9UZdypq/atlViXyJd/KQJBNFsHCZaP/HUryua0wWYh
	wo3SY9oyi9Wo7T3pjvsDw==
Date: Thu, 15 Oct 2009 01:09:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [RFC In-kernel benchmarks 0/3] Introduce in kernel benchmarks
In-Reply-To: <20091013200233.260324963@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910150107130.8299@chino.kir.corp.google.com>
References: <20091013200233.260324963@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Christoph Lameter wrote:

> In kernel benchmarks are benchmarks that directly run in kernel space.
> 
> The test modules are regular kernel modules that can be loaded with
> 
> 	modprobe slab_test
> 
> or so. 
> 
> The initialization function of the module will then run the test
> and fail so that the module is not loaded. The output of the test
> results will be written to the system log.
> 
> This is a rough draft. I have used these in the past to benchmark
> page allocator, slab allocator and vmstat performance.
> 

I like the addition of these benchmarks to the kernel source, I've been 
adding Mathieu's slab benchmark to my tree for a while.  It looks like 
they all need some degree of cleanup, though: they have checkpatch 
warnings, they frequently do not handle memory allocation failures, and it 
would be nice to have a consistent loglevel for all the results.
