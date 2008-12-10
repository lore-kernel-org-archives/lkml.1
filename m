Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYLJKO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYLJKO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYLJKOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:14:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60590 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYLJKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:14:47 -0500
Date: Wed, 10 Dec 2008 11:26:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       eranian@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] Performance Counters for Linux, v2
Message-ID: <20081210102620.GE23556@one.firstfloor.org>
References: <20081208012211.GA23106@elte.hu> <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com> <20081209134636.GA1926@elte.hu> <18750.61143.101922.949701@cargo.ozlabs.ibm.com> <87skoxc6qo.fsf@basil.nowhere.org> <18751.18735.539555.111549@drongo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18751.18735.539555.111549@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 03:44:31PM +1100, Paul Mackerras wrote:
> Andi Kleen writes:
> 
> > When you say counting you should also include "event ring buffers with
> > metadata", like PEBS on Intel x86. 
> 
> I'm not familiar with PEBS.  Maybe it's something different again,
> neither sampling nor counting, but a third thing?

Yes it's a third thing. A CPU controlled ring event buffer. See Stephane's 
description.

There's also some crosses, e.g. AMD's IBS (which is essentially a counter +
some additional registers to give more details about the interrupted
instruction)

-Andi

-- 
ak@linux.intel.com
