Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYIWQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYIWQaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYIWQao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:30:44 -0400
Received: from fhw-relay07.plus.net ([212.159.14.148]:54786 "EHLO
	fhw-relay07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYIWQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:30:43 -0400
Message-ID: <48D919A9.5000708@yahoo.com>
Date: Tue, 23 Sep 2008 17:30:33 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu>
In-Reply-To: <20080923115323.GA27240@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: ae70f55b2cb48d018d0e8bd3b12474d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
>> Ingo Molnar wrote:
>>> well, since they went away after you enabled CONFIG_PREEMPT=y, they are 
>>> definitely in-kernel latencies, not any external SMM latencies.
>>>
>>> I.e. they are inherently fixable. Could you enable:
>>>
>>>   CONFIG_DYNAMIC_FTRACE=y
>>>   CONFIG_FTRACE_MCOUNT_RECORD=y
>>>
>>> that should make the traces a lot more verbose - every kernel function  
>>> executed in the latency path will be logged. That way we'll be able to  
>>> say which one takes that long.
>> I do not appear to have the CONFIG_FTRACE_MCOUNT_RECORD option in 
>> 2.6.27rc7. Is it an option that is only in -tip ?
> 
> yeah - it's a new ftrace feature queued up for v2.6.28.

I've been struggling to boot -tip/master - currently it blows up just 
after printing SLUB information saying:

BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c0120078>] account_system_time+0x48/0x120
*pde = 00000000
Thread overran stack, or stack corrupted
Oops: 0002 [#1] PREEMPT

-- 
Sitsofe | http://sucs.org/~sits/
