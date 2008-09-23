Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYIWGdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYIWGdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYIWGdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:33:31 -0400
Received: from pih-relay06.plus.net ([212.159.14.19]:47329 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYIWGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:33:30 -0400
Message-ID: <48D88DB4.9020003@yahoo.com>
Date: Tue, 23 Sep 2008 07:33:24 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu>
In-Reply-To: <20080922115749.GE14301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: af6a8bb78135725b2edaf60b7b90a3cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> well, since they went away after you enabled CONFIG_PREEMPT=y, they are 
> definitely in-kernel latencies, not any external SMM latencies.
> 
> I.e. they are inherently fixable. Could you enable:
> 
>   CONFIG_DYNAMIC_FTRACE=y
>   CONFIG_FTRACE_MCOUNT_RECORD=y
> 
> that should make the traces a lot more verbose - every kernel function 
> executed in the latency path will be logged. That way we'll be able to 
> say which one takes that long.

I do not appear to have the CONFIG_FTRACE_MCOUNT_RECORD option in 
2.6.27rc7. Is it an option that is only in -tip ?

-- 
Sitsofe | http://sucs.org/~sits/
