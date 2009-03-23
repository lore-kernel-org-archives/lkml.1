Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbZCWSJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbZCWSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbZCWSJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:09:44 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:45252 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbZCWSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:09:43 -0400
Date: Mon, 23 Mar 2009 14:06:18 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/6] slab: introduce __kfree_rcu
In-Reply-To: <84144f020903231049o11de5287w7bdb5c28e866dafb@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903231404330.29908@qirst.com>
References: <49AD3433.9000001@cn.fujitsu.com>  <1237794502.6313.21.camel@penberg-laptop>  <alpine.DEB.1.10.0903230931570.4095@qirst.com>  <20090323155938.GA27151@elte.hu>  <alpine.DEB.1.10.0903231234110.11796@qirst.com>  <20090323165639.GA6841@elte.hu>
 <84144f020903231049o11de5287w7bdb5c28e866dafb@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Pekka Enberg wrote:

> Well, like I said, it was a minor nitpick, that's all. I would prefer
> it the way I and Ingo suggested but if you don't want to change it,
> that's fine as well.

Maybe put some macros in to make these "pickup the context" thingies more
readable. Or would a macro obfuscate things?

#define GET_SLAB_CONTEXT(pointer, slab, cache, page)

	and

#define GET_OBJECT_CONTEXT(pointer, slab, index, offset) ?


