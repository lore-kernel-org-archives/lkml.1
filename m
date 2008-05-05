Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYEELLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYEELLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYEELK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:10:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbYEELK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:10:56 -0400
Date: Mon, 5 May 2008 13:10:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080505111029.GA9948@elte.hu>
References: <20080504134838.GA21487@Krystal> <20080505065559.GD3350@elte.hu> <20080505105915.GA26444@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505105915.GA26444@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > hm, i'm not sure about this. I've implemented system call tracing in 
> > -rt [embedded in the latency tracer] and it only needed changes in 
> > entry.S, not in every system call site. Now, granted, that tracer 
> > was simpler than what LTTng tries to do, but do we _really_ need 
> > more complexity? A trace point that simply expresses:
> > 
> >    sys_call_event(int sysno, long param1, long param2, long param3,
> >                              long param4, long param5, long param6);
> > 
> 
> That would work for all system calls that doesn't have parameters like 
> "const char __user *filename".

what's the problem with them? Do you want to follow those parameters?

	Ingo
