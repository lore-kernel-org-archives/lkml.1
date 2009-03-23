Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbZCWTD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbZCWTD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZCWTDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:03:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37179 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZCWTDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:03:18 -0400
Message-ID: <49C7DC04.9060006@cs.helsinki.fi>
Date: Mon, 23 Mar 2009 20:59:16 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/6] slab: introduce __kfree_rcu
References: <49AD3433.9000001@cn.fujitsu.com>  <1237794502.6313.21.camel@penberg-laptop>  <alpine.DEB.1.10.0903230931570.4095@qirst.com>  <20090323155938.GA27151@elte.hu>  <alpine.DEB.1.10.0903231234110.11796@qirst.com>  <20090323165639.GA6841@elte.hu> <84144f020903231049o11de5287w7bdb5c28e866dafb@mail.gmail.com> <alpine.DEB.1.10.0903231404330.29908@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0903231404330.29908@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Pekka Enberg wrote:
>> Well, like I said, it was a minor nitpick, that's all. I would prefer
>> it the way I and Ingo suggested but if you don't want to change it,
>> that's fine as well.

Christoph Lameter wrote:
> Maybe put some macros in to make these "pickup the context" thingies more
> readable. Or would a macro obfuscate things?
> 
> #define GET_SLAB_CONTEXT(pointer, slab, cache, page)
> 
> 	and
> 
> #define GET_OBJECT_CONTEXT(pointer, slab, index, offset) ?

It would obfuscate things :-)
