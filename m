Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZBRRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZBRRSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZBRRSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:18:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZBRRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:18:36 -0500
Date: Wed, 18 Feb 2009 09:17:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
 ipi fallback for smp_call_function_many())
In-Reply-To: <20090218171048.GA12299@elte.hu>
Message-ID: <alpine.LFD.2.00.0902180915430.21686@localhost.localdomain>
References: <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de> <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain>
 <20090218162116.GC29863@elte.hu> <alpine.LFD.2.00.0902180828430.21686@localhost.localdomain> <20090218165808.GA9120@elte.hu> <20090218170517.GA9769@elte.hu> <20090218171048.GA12299@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Feb 2009, Ingo Molnar wrote:
> 
> ok, it's documented:
> 
>    Intel® 64 and IA-32 Architectures
>    Software Developer’s Manual
>                            Volume 3A:
>        System Programming Guide, Part 1
> 
>  9.5.3        MSR Access in x2APIC Mode

Well, mine says

	9.5.3 Error Handling

so I guess I need to download a newer version. After all, mine is 
"ancient" in being a year old (the February-2008 version) and not covering 
x2APIC at all.

			Linus
