Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYIWTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYIWTkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYIWTkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:40:04 -0400
Received: from main.gmane.org ([80.91.229.2]:44531 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYIWTkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:40:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: How how latent should non-preemptive scheduling be?
Date: Tue, 23 Sep 2008 20:39:56 +0100
Message-ID: <48D9460C.5040504@yahoo.com>
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
X-Gmane-NNTP-Posting-Host: 87.112.14.28.plusnet.ptn-ag1.dyn.plus.net
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
In-Reply-To: <48D919A9.5000708@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> I've been struggling to boot -tip/master - currently it blows up just 
> after printing SLUB information saying:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000004
> IP: [<c0120078>] account_system_time+0x48/0x120
> *pde = 00000000
> Thread overran stack, or stack corrupted
> Oops: 0002 [#1] PREEMPT

OK this BUG seems to have gone away in the past few hours.

Ingo when you were asking for the ftrace report I presume that would be 
for a non preempt kernel (as a preemptive one only showed a very worst 
latency of 19657 us in one exceptional case)?

-- 
Sitsofe | http://sucs.org/~sits/

