Return-Path: <linux-kernel-owner+w=401wt.eu-S1762324AbYCUU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324AbYCUU4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbYCUU4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:56:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbYCUU4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:56:14 -0400
Date: Fri, 21 Mar 2008 21:55:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2/2] vmallocinfo: Add caller information
Message-ID: <20080321205559.GC3509@elte.hu>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com> <20080319214227.GA4454@elte.hu> <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com> <20080321110008.GW20420@elte.hu> <Pine.LNX.4.64.0803211034140.18671@schroedinger.engr.sgi.com> <20080321184526.GB6571@elte.hu> <Pine.LNX.4.64.0803211212520.19558@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803211212520.19558@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> > the best i found for lockdep was to include a fair number of them, 
> > and to skip the top 3. struct vm_area that vmalloc uses isnt 
> > space-critical, so 4-8 entries with a 3 skip would be quite ok. (but 
> > can be more than that as well)
> 
> STACKTRACE depends on STACKTRACE_SUPPORT which is not available on all 
> arches? alpha blackfin ia64 etc are missing it?

one more reason for them to implement it.

> I thought there were also issues on x86 with optimizations leading to 
> weird stacktraces?

at most there can be extra stack trace entries. This is for debugging, 
so if someone wants exact stacktraces, FRAME_POINTERS will certainly 
improve them.

	Ingo
