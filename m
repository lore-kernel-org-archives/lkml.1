Return-Path: <linux-kernel-owner+w=401wt.eu-S1765972AbZFLSAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765972AbZFLSAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765130AbZFLSAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:00:35 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58691 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765799AbZFLSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:00:34 -0400
Message-ID: <4A3297B5.7080401@linux.vnet.ibm.com>
Date: Fri, 12 Jun 2009 11:00:21 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: powerpc: Implement generalized cache
 events for POWER processors
References: <18992.36329.189378.17992@drongo.ozlabs.ibm.com> <18992.36430.933526.742969@drongo.ozlabs.ibm.com> <20090611100720.GC12703@elte.hu> <18993.58058.194954.997480@drongo.ozlabs.ibm.com>
In-Reply-To: <18993.58058.194954.997480@drongo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Ingo Molnar writes:
> 

> Yeah.
> 
> When thinking about having "composite" events, i.e. a counter whose
> value is computed from two or more hardware counters, I couldn't see
> how to do sampling in the general case.  It's easy if we're just
> adding multiple counters, but sampling when subtracting counters is
> hard.  For example, if you want to sample every N cache hits, and
> you're computing hits as accesses - misses, I couldn't see a decent
> way to know when to take the sample, not without having to take an
> interrupt on every access in some circumstances.

The PAPI equivalent of this, its preset aka standard events, do not allow 
profiling or interrupt on overflow for "derived" events.  "derived events" has 
the same meaning as your composite events.  So there is precedent for not 
allowing sampling on them.

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain

