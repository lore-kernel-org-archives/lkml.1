Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbZFWXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbZFWXAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbZFWXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:00:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:50103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFWXAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:00:21 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245795173.26280.17.camel@localhost.localdomain>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245795173.26280.17.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 04:29:52 +0530
Message-Id: <1245797992.4954.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 03:42 +0530, Jaswinder Singh Rajput wrote:

> > Note, branches are special - we dont really have 'branch loads', 
> > branches are executions. 'Branches' and 'Branch-misses' are the 
> > right term.
> > 
> > Do you agree?
> > 
> 
> Event we used for (BPU, READ, ACCESS) is 'branch instructions retired'
> 
> So 'branch loads' we mean 'branch instruction loaded and retired'
> 
> I like all of them : 'branch loads', 'branch retired' or 'branches'
> 
> Please let me know, which one is best option so that I can prepare the
> patch.
> 

Or if branches is special and following values are always invalid :

 (BPU, WRITE, ACCESS)
 (BPU, WRITE, MISS)
 (BPU, PREFETCH, ACCESS)
 (BPU, PREFTECH, MISS)

then can we move BPU to some other category from Hardware cache
counters.

Thanks,
--
JSR



