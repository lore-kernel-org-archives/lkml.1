Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZJBRQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZJBRQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZJBRP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:15:59 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:48822 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753645AbZJBRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:15:58 -0400
Date: Fri, 2 Oct 2009 13:10:35 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rusty@rustcorp.com.au, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 00/20] Introduce per cpu atomic operations and
 avoid per cpu address arithmetic
In-Reply-To: <4AC5C836.8000502@kernel.org>
Message-ID: <alpine.DEB.1.10.0910021310150.26189@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <4AC5C836.8000502@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Tejun Heo wrote:

> cl@linux-foundation.org wrote:
> > V3->V4:
> > - Fix various macro definitions.
> > - Provider experimental percpu based fastpath that does not disable
> >   interrupts for SLUB.
>
> The series looks very good to me.  percpu#for-next now has ia64 bits
> included and the legacy allocator is gone there so it can carry this
> series.  Sans the last one, they seem they can be stable and
> incremental from now on, right?  Shall I include this series into the
> percpu tree?

You can include all but the last patch that is experimental.

