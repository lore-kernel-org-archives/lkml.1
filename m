Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZFXIeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZFXIeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZFXIeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:34:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZFXIeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:34:03 -0400
Date: Wed, 24 Jun 2009 10:33:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Christoph Hellwig <hch@infradead.org>
Cc: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Tom Zanussi <tzanussi@gmail.com>, karim@opersys.com,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Lai Jiangshan <laijs@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: Dual-licensing LTTng, marker and tracepoints under
	GPLv2+/LGPLv2.1+
Message-ID: <20090624083334.GB16850@elte.hu>
References: <4A412702.80707@polymtl.ca> <20090623191128.GA19010@Krystal> <20090623191513.GA20253@Krystal> <20090624004356.GB28911@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624004356.GB28911@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> Hi,
> 
> We want to re-license LTTng as
> 
>   dual-license GPLv2 (or better)/LGPLv2.1 (or better)
> 
> to facilitate code exchange between the GPLv2 LTTng kernel tracer 
> and LGPLv2.1 userspace LTTng tracing library.  This will also 
> include kernel/marker.c, include/linux/marker.h, 
> kernel/tracepoint.c and include/linux/tracepoint.h. For the LTTng 
> tree, everything under the ltt/ subdirectory is targeted.
> 
> I am the main author of most of these files, and I allow such 
> license change as far as my code is concerned. Additionally, we 
> need the approval of most people who contributed code to either 
> LTTng, Linux Kernel Marker and Tracepoints.

Why dont you license the user-space library under the GPLv2?

Also, i dont agree that such interfaces should be ABIs, hence i 
oppose the librarization of such raw kernel interfaces. For example 
markers will be removed in the future, and tracepoints will sure 
undergo more corrective iterations as well.

	Ingo
