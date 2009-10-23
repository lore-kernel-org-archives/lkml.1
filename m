Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbZJWU5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbZJWU5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZJWU5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:57:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZJWU5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:57:14 -0400
Date: Fri, 23 Oct 2009 22:57:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@au1.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_events: zero time running and enabled, but non-zero count
Message-ID: <20091023205711.GB8356@elte.hu>
References: <4AE20102.8010002@linux.vnet.ibm.com> <20091023193246.GA3139@elte.hu> <4AE21655.6040403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE21655.6040403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

>> Btw., you might want to consider putting such testcases into a new 
>> 'perf test' kind of utility (under tools/perf/builtin-test.c) that 
>> does various tests such as reading a count and validating the 
>> time-running/time-enabled values - so that we can see any bugs 
>> directly.
>
> I'll see if I can put the test case in some sort of acceptable format 
> like that.  Maybe we can use this one test case as the starting point 
> for builtin-test.c.

Yeah. Feel free to add just something minimal that solves your problem. 
Others will add their testcases too i'm sure, once the basic command is 
there.

	Ingo
