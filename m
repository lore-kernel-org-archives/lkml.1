Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZJBRUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZJBRUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbZJBRUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:20:18 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:45012 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757547AbZJBRUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:20:13 -0400
Date: Fri, 2 Oct 2009 13:15:06 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [this_cpu_xx V4 00/20] Introduce per cpu atomic operations and
 avoid per cpu address arithmetic
In-Reply-To: <20091002095455.GC21427@elte.hu>
Message-ID: <alpine.DEB.1.10.0910021313270.26189@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <4AC5C836.8000502@kernel.org> <20091002095455.GC21427@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Ingo Molnar wrote:

> One final step/cleanup seems to be missing from it: it should replace
> current uses of percpu_op() [percpu_read(), etc.] in the x86 tree and
> elsewhere with the new this_cpu_*() primitives. this_cpu_*() is using
> per_cpu_from_op/per_cpu_to_op directly, we dont need those percpu_op()
> variants anymore.

Well after things settle with this_cpu_xx we can drop those.

> There should also be a kernel image size comparison done for that step,
> to make sure all the new primitives are optimized to the max on the
> instruction level.

Right. There will be a time period in which other arches will need to add
support for this_cpu_xx first.


