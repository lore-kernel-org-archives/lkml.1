Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZCEOu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZCEOu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZCEOuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:50:00 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45134 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754693AbZCEOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:49:58 -0500
Date: Thu, 5 Mar 2009 09:39:03 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/6] slub: introduce __kfree_rcu
In-Reply-To: <49AF28C4.1000300@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0903050938300.22053@qirst.com>
References: <49AD343E.6010903@cn.fujitsu.com> <alpine.DEB.1.10.0903041003200.3850@qirst.com> <49AF28C4.1000300@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Lai Jiangshan wrote:

> The first parameter of __kfree_rcu() is unused in slab,slub,slqb.
> (I used it before, for CONFIG_SLUB_DEBUG=y ...etc. But I found
> these debugging code is needless)
>
> Object sizes of the memory objects in slob's kmalloc-slab are various.
> We hardly calculate the start address of the object from the rcu address.

But you can start with the descriptor at the beginning of the page and
scan until you find the object.

