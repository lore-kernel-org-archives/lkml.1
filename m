Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZFXSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZFXSSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZFXSSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:18:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:56239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZFXSSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:18:46 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090624180759.GG7576@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245795173.26280.17.camel@localhost.localdomain>
	 <20090624084033.GA18713@elte.hu>
	 <1245866393.3181.9.camel@localhost.localdomain>
	 <20090624180759.GG7576@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 23:48:10 +0530
Message-Id: <1245867490.3181.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 20:07 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > 
> > OK, We will show :
> > 'branch loads'           -> 'branches'
> > 'branch load-misses'     -> 'branch-misses'
> > 
> > now issue is how we can show :
> > 
> > 'branch stores'          ->  ?
> > 'branch store-misses'    ->  ?
> > 
> > 'branch prefetches'      ->  ?
> > 'branch prefetch-misses' ->  ?
> 
> there's no such thing as a 'branch store'. Instructions are not 
> stored. We shouldnt display those.
> 
> They are prefetched sometimes speculatively ... not sure there are 
> events for them ... are there?
> 

yes, you are right there is no such events.

But I need to test and display all.

If I need to to need to handle branch as special case, then better to
make separate array for branches and remove from hw_cache array.

Is it OK.

Thanks,

