Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbYGINOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbYGINOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYGINOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:14:16 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44500 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYGINON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:14:13 -0400
X-Auth-Info: NcMUykYZEwxNeaDeUbcvf0XMrr4LSzkyNfiVlj+yoXY=
X-Auth-Info: NcMUykYZEwxNeaDeUbcvf0XMrr4LSzkyNfiVlj+yoXY=
X-Auth-Info: NcMUykYZEwxNeaDeUbcvf0XMrr4LSzkyNfiVlj+yoXY=
X-Auth-Info: NcMUykYZEwxNeaDeUbcvf0XMrr4LSzkyNfiVlj+yoXY=
X-Auth-Info: NcMUykYZEwxNeaDeUbcvf0XMrr4LSzkyNfiVlj+yoXY=
X-Auth-Info: 0NLLVblehdTcl6pAGq1p6HQxECh3LK1axNhxXRhunzk=
X-Auth-Info: 0NLLVblehdTcl6pAGq1p6HQxECh3LK1axNhxXRhunzk=
Message-ID: <4874B9D5.1020309@grandegger.com>
Date: Wed, 09 Jul 2008 15:15:01 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU	issue?
References: <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com> <Pine.LNX.4.58.0807052041350.8466@gandalf.stny.rr.com> <48709348.6000101@grandegger.com> <20080708150826.GA30586@pengutronix.de> <4873C363.3070306@grandegger.com> <4874B4C0.5090500@pengutronix.de>
In-Reply-To: <4874B4C0.5090500@pengutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fu (without n)

Luotao Fu wrote:
> Hi Wolfgang,
> 
> Wolfgang Grandegger wrote:
>> Hi Fun,
> 
> What's so funny? ;-)

Ah, oh, just a funny typo ;-).

> [...]
> 
>> But as Steven pointed out, the preempt_enable_noresched at that place
>>  might be illegal, anyway. In 2.6.25-rt, trace_mark() is no longer
>> used and I do not see an improvement with CONFIG_RCU_TRAC any more.
>> Latencies go up to 600us. I also tried with CONFIG_RCU_BOOST
>> disabled, but it did not improve the latencies. Actually, I still
>> measure significantly different latencies with 2.6.24.4-rt4,
>> 2.6.24.7-rt14 and 2.6.25.8-rt7, which is quite frustrating. As you
>> seem not be able to reproduce my high latencies, I wonder if there
>> are some toolchain or glibc related issues.
> 
> I took a quick look into the rcppreempt boost stuff in 2.6.24-rt and
> 2.6.25-rt. As you have mentioned, trace_mark is no more used in
> 2.6.24-rt. Instead of that flags are used to detect if the task is
> preempted. It might indeed probably be some toolchain issue.
> My powerpc toolchain I'm using here contains gcc 4.1.2 and glibc 2.5

OK, in the past you have been able to reproduce the high latencies with 
2.6.24-rt1 and CONFIG_RCU_TRACE disabled, IIRC. Did you use a different 
toolchain at that time?

Wolfgang.
