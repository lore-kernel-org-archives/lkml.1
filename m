Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYLAXCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYLAXCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYLAXCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:02:40 -0500
Received: from tundra.namei.org ([65.99.196.166]:32976 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYLAXCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:02:40 -0500
Date: Tue, 2 Dec 2008 10:02:18 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Eric Biederman <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Eric Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH 1/2] cpumask: prepare for iterators to only go to
 nr_cpu_ids/nr_cpumask_bits.: core
In-Reply-To: <200812011841.27839.rusty@rustcorp.com.au>
Message-ID: <alpine.LRH.1.10.0812021001570.21992@tundra.namei.org>
References: <200812011841.27839.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Rusty Russell wrote:

> 
> Impact: cleanup
> 
> In future, all cpumask ops will only be valid (in general) for bit
> numbers < nr_cpu_ids.  So use that instead of NR_CPUS in iterators
> and other comparisons.
> 
> This is always safe: no cpu number can be >= nr_cpu_ids, and
> nr_cpu_ids is initialized to NR_CPUS at boot.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: James Morris <jmorris@namei.org>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
