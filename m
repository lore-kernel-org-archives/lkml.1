Return-Path: <linux-kernel-owner+w=401wt.eu-S965427AbZLQTaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbZLQTaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965422AbZLQT35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:29:57 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:36401 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424AbZLQT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:29:56 -0500
Date: Thu, 17 Dec 2009 13:28:34 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
 cleanup
In-Reply-To: <20091217133958.GA21618@Krystal>
Message-ID: <alpine.DEB.2.00.0912171327220.3638@router.home>
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org> <20091216014031.GA12282@Krystal> <4B283BFE.2040005@kernel.org> <20091217133958.GA21618@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, I would need:
>
> this_cpu_cmpxchg(scalar, oldv, newv)
>   (maps to x86 cmpxchg)
>
> this_cpu_add_return(scalar, value)
>   (maps to x86 xadd)
>
> too. Is that a planned addition ?

It was not necessary. Its easy to add though.

> (while we are at it, we might as will add the xchg instruction,
> althrough it has an implied LOCK prefix on x86).

Well yeah thats a thorny one. One could use the cmpxchg instead?

