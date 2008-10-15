Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYJOVQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYJOVQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYJOVQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:16:23 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:59114 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbYJOVQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:16:22 -0400
Date: Thu, 16 Oct 2008 01:18:12 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call mechanism
Message-ID: <20081015211812.GA30735@2ka.mipt.ru>
References: <20081012194427.2e21c22e@infradead.org> <20081015014117.faff3a61.akpm@linux-foundation.org> <20081015075246.2e1610f3@infradead.org> <20081015095905.41219c9d.akpm@linux-foundation.org> <20081015162316.0a0c284a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015162316.0a0c284a@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan.

[ I've switched to the different mail system recently, you could update
you blacklist filter, or we can bury the war axe: ipw2100 still does not
work with power tricks :) ]

On Wed, Oct 15, 2008 at 04:23:16PM -0400, Arjan van de Ven (arjan@infradead.org) wrote:
> On Wed, 15 Oct 2008 09:59:05 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > 
> > > > Please talk to Evgeniy about his new thread_pool stuff which I've
> > > > suggested become a generic library.
> > 
> > ^^ this?
> 
> if thread pools can deliver me the same ordering guarantees.....
> which I kinda doubt given the point of the concept of them..

One can schedule execution on given thread in the pool (actually on
given set of threads, which have the same private pointer), if needed
threads are busy, caller will sleep, if there are no such threads,
execution fails. Although I'm not quite sure this is exactly what you
asked for.

-- 
	Evgeniy Polyakov
