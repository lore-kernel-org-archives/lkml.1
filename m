Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbZDCOzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbZDCOzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbZDCOrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:47:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbZDCOrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:47:22 -0400
Date: Fri, 3 Apr 2009 16:43:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Mel Gorman <mel@csn.ul.ie>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com,
       apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090403144344.GA9643@elte.hu>
References: <20090401125506.GA6406@csn.ul.ie> <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie> <20090401134917.GC18677@elte.hu> <1238597398.23857.11.camel@penberg-laptop> <20090401152251.GB23390@elte.hu> <1238656331.26286.17.camel@penberg-laptop> <20090403042131.GA15669@localhost> <20090403141743.GF8875@elte.hu> <49D61F09.2080808@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D61F09.2080808@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Ingo Molnar wrote:
>> * Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:
>>
>>> One thing I'm not sure about this patch is whether it manages to  
>>> record an allocation only once, i.e. does it log a single event  
>>> when/if the slab allocator requests pages? Some time ago I sent a  
>>> patch adding GFP_NOTRACE to gfp.h, but was rejected. Maybe this  
>>> could be a way out of the mess.
>>>
>>> (GFP_NOTRACE would also allow us to log "backend" allocations easily 
>>> and treat them separately, for the record, or simply filter them 
>>> out.)
>>
>> makes a lot of sense IMO to annotate these via a GFP flag.
>
> Yup, make sense. I think I rejected the patch (did I?) because I 
> wanted to fix the slub/slab mess differently but here it makes 
> perfect sense.

I'm wondering how much could be shared with the kmemcheck's 
internal-allocation annotations. There's some overlap (although not 
a full match) i suspect?

	Ingo
