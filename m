Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYJVPtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYJVPtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYJVPtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:49:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53809 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbYJVPtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:49:01 -0400
Date: Wed, 22 Oct 2008 17:48:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] Implement semaphore latency tracer
Message-ID: <20081022154851.GL23060@elte.hu>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com> <1223817124-27239-6-git-send-email-edwintorok@gmail.com> <1223838786.8634.8.camel@lappy.programming.kicks-ass.net> <48F259A7.2030800@gmail.com> <20081022152842.GI23060@elte.hu> <48FF49BD.8000608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48FF49BD.8000608@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> On 2008-10-22 18:28, Ingo Molnar wrote:
> > hm, but the most common synchronization primitive are mutexes - and 
> > those are not covered by your patchset.
> >   
> 
> Indeed. I've seen a patch from Jason Baron to introduce tracepoints 
> for mutexes, but the conclusion was that the tracepoints should be in 
> lockstat instead.
> 
> And if lockstat is enabled Peter Zijlstra's 'contend with points' 
> patch seems to do exactly what I want to.
> 
> However I think it would be useful to have (a tracepoints based?) 
> latency tracker, which can be enabled/disabled at runtime, and which 
> doesn't add any data to the mutex/semaphore structures. My patchset 
> was a first attempt towards that, but it seems that such use of 
> tracepoints is not welcome at this time?
> 
> Please tell me if I should continue working on this, or if I my 
> patches are designed totally on the wrong way.

i think if you hook into Peter's lockstat APIs that should give us a 
pretty good tracer, with no ugliness introduced. That would be rather 
interesting. Peter, do you concur?

	Ingo
