Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYIWLxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYIWLxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYIWLxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:53:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbYIWLxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:53:32 -0400
Date: Tue, 23 Sep 2008 13:53:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080923115323.GA27240@elte.hu>
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D88DB4.9020003@yahoo.com>
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

* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Ingo Molnar wrote:
>> well, since they went away after you enabled CONFIG_PREEMPT=y, they are 
>> definitely in-kernel latencies, not any external SMM latencies.
>>
>> I.e. they are inherently fixable. Could you enable:
>>
>>   CONFIG_DYNAMIC_FTRACE=y
>>   CONFIG_FTRACE_MCOUNT_RECORD=y
>>
>> that should make the traces a lot more verbose - every kernel function  
>> executed in the latency path will be logged. That way we'll be able to  
>> say which one takes that long.
>
> I do not appear to have the CONFIG_FTRACE_MCOUNT_RECORD option in 
> 2.6.27rc7. Is it an option that is only in -tip ?

yeah - it's a new ftrace feature queued up for v2.6.28.

	Ingo
