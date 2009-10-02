Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZJBJTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZJBJTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZJBJTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:19:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:56668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZJBJS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:18:59 -0400
Message-ID: <4AC5C572.9040309@kernel.org>
Date: Fri, 02 Oct 2009 18:18:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rusty@rustcorp.com.au, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 02/20] this_cpu: X86 optimized this_cpu operations
References: <20091001212521.123389189@gentwo.org> <20091001212557.963565363@gentwo.org>
In-Reply-To: <20091001212557.963565363@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 09:18:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cl@linux-foundation.org wrote:
> Basically the existing percpu ops can be used for this_cpu variants that allow
> operations also on dynamically allocated percpu data. However, we do not pass a
> reference to a percpu variable in. Instead a dynamically or statically
> allocated percpu variable is provided.
> 
> Preempt, the non preempt and the irqsafe operations generate the same code.
> It will always be possible to have the requires per cpu atomicness in a single
> RMW instruction with segment override on x86.
> 
> 64 bit this_cpu operations are not supported on 32 bit.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
