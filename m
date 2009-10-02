Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZJBJbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZJBJbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbZJBJbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:31:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:59748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435AbZJBJbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:31:15 -0400
Message-ID: <4AC5C836.8000502@kernel.org>
Date: Fri, 02 Oct 2009 18:30:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rusty@rustcorp.com.au, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 00/20] Introduce per cpu atomic operations and
 avoid per cpu address arithmetic
References: <20091001212521.123389189@gentwo.org>
In-Reply-To: <20091001212521.123389189@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 09:30:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cl@linux-foundation.org wrote:
> V3->V4:
> - Fix various macro definitions.
> - Provider experimental percpu based fastpath that does not disable
>   interrupts for SLUB.

The series looks very good to me.  percpu#for-next now has ia64 bits
included and the legacy allocator is gone there so it can carry this
series.  Sans the last one, they seem they can be stable and
incremental from now on, right?  Shall I include this series into the
percpu tree?

Thanks.

-- 
tejun
