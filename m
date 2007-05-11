Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbXEKRJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbXEKRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbXEKRI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:08:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55399 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754805AbXEKRI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:08:57 -0400
Date: Fri, 11 May 2007 10:08:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
In-Reply-To: <20070511155621.GA13150@elte.hu>
Message-ID: <Pine.LNX.4.64.0705111008380.32716@schroedinger.engr.sgi.com>
References: <20070511131541.992688403@chello.nl> <20070511155621.GA13150@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Ingo Molnar wrote:

> given how nice this looks already, have you considered completely 
> replacing rwsems with this? I suspect you could test the correctness of 
> that without doing a mass API changeover, by embedding struct rw_mutex 
> in struct rwsem and implementing kernel/rwsem.c's API that way. (the 
> real patch would just flip it all over to rw-mutexes)

Ummmm... How much memory would that cost on large systems?

