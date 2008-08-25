Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYHYTVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYHYTVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYHYTVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:21:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYHYTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:21:16 -0400
Subject: Re: [RFC PATCH] Fair low-latency rwlock v5
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080817191034.GA5258@Krystal>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com>
	 <20080816154330.GA5880@Krystal>
	 <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org>
	 <20080816211954.GB7358@Krystal>
	 <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org>
	 <20080817075335.GA25019@Krystal>
	 <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org>
	 <20080817191034.GA5258@Krystal>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 21:20:42 +0200
Message-Id: <1219692042.8515.119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-17 at 15:10 -0400, Mathieu Desnoyers wrote:

> Fair low-latency rwlock v5
> 
> Fair low-latency rwlock provides fairness for writers against reader threads,
> but lets softirq and irq readers in even when there are subscribed writers
> waiting for the lock. Writers could starve reader threads.

New lock types should come with lockdep support.

Also, if you're serious about -rt, you'll need to consider full PI.

