Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZCEUC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZCEUC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZCEUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:02:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:34321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZCEUCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:02:15 -0500
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305194127.GA2039@elte.hu>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
	 <1236279393.3316.13.camel@localhost.localdomain>
	 <1236281661.5187.432.camel@laptop>  <20090305194127.GA2039@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 01:31:55 +0530
Message-Id: <1236283315.6457.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 20:41 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2009-03-06 at 00:26 +0530, Jaswinder Singh Rajput wrote:
> > 
> > > But kerneltop is still not working and I am not getting any NMI Interrupts.
> > 
> > Does the below work for you?
> > 
> > The BKGD suggests its 48 for all existing machines (it 
> > certainly is for mine).
> 
> Yeah, this did the trick on AMD/Barcelona!
> 

Nice.

but on my AMD box I got interrupts and NMI for some time:

NMI:        100    1108209   Non-maskable interrupts
LOC:        213     192815   Local timer interrupts
CNT:        100    1108206   Performance counter interrupts
RES:      21132      20397   Rescheduling interrupts

but kerneltop does not show anything, it only shows # irqs/sec for some
time and then irqs also become 0.

Here is demg:

kerneltop 
[  196.677297] Uhhuh. NMI received for unknown reason 00 on CPU 1.
[  196.677297] Do you have a strange power saving mode enabled?
[  196.677297] Dazed and confused, but trying to continue
[  198.854293] PERFMON: max interrupts exceeded!
[  198.865302] PERFMON: max interrupts exceeded!
[  198.866304] PERFMON: max interrupts exceeded!
[  206.066271] PERFMON: max interrupts exceeded!
[  206.067304] PERFMON: max interrupts exceeded!
[  206.068265] PERFMON: max interrupts exceeded!
[  211.176291] PERFMON: max interrupts exceeded!
[  211.177302] PERFMON: max interrupts exceeded!
[  211.235304] PERFMON: max interrupts exceeded!
[  211.236296] PERFMON: max interrupts exceeded!
[  214.245302] PERFMON: max interrupts exceeded!
[  225.257276] PERFMON: max interrupts exceeded!
[  225.258271] PERFMON: max interrupts exceeded!
[  297.385301] PERFMON: max interrupts exceeded!
[  297.386290] PERFMON: max interrupts exceeded!
[  310.405304] PERFMON: max interrupts exceeded!
[  392.677261] Uhhuh. NMI received for unknown reason 00 on CPU 1.
[  392.677261] Do you have a strange power saving mode enabled?
[  392.677261] Dazed and confused, but trying to continue
[  394.837275] PERFMON: max interrupts exceeded!
[  394.848268] PERFMON: max interrupts exceeded!
[  394.849266] PERFMON: max interrupts exceeded!
[  396.891309] PERFMON: max interrupts exceeded!
[  396.892294] PERFMON: max interrupts exceeded!
[  397.415302] PERFMON: max interrupts exceeded!
[  397.594299] PERFMON: max interrupts exceeded!
[  398.395302] PERFMON: max interrupts exceeded!
[  398.919304] PERFMON: max interrupts exceeded!
[  403.839309] __ratelimit: 1 callbacks suppressed
[  403.839319] PERFMON: max interrupts exceeded!
[  403.840302] PERFMON: max interrupts exceeded!
[  403.841298] PERFMON: max interrupts exceeded!
[  403.842297] PERFMON: max interrupts exceeded!
[  403.843267] PERFMON: max interrupts exceeded!
[  403.853303] PERFMON: max interrupts exceeded!
[  403.854290] PERFMON: max interrupts exceeded!
[  403.855301] PERFMON: max interrupts exceeded!
[  403.857301] PERFMON: max interrupts exceeded!
[  403.858304] PERFMON: max interrupts exceeded!
[  409.097310] __ratelimit: 13 callbacks suppressed
[  409.097321] PERFMON: max interrupts exceeded!
[  409.098299] PERFMON: max interrupts exceeded!
[  411.138303] PERFMON: max interrupts exceeded!
[  413.177301] PERFMON: max interrupts exceeded!
[  413.178289] PERFMON: max interrupts exceeded!
[  414.442311] PERFMON: max interrupts exceeded!
[  415.217304] PERFMON: max interrupts exceeded!
[  415.218291] PERFMON: max interrupts exceeded!
[  417.257307] PERFMON: max interrupts exceeded!
[  417.258294] PERFMON: max interrupts exceeded!
[  418.585295] PERFMON: max interrupts exceeded!
[  418.600293] PERFMON: max interrupts exceeded!
[  427.436301] PERFMON: max interrupts exceeded!
[  427.437307] PERFMON: max interrupts exceeded!
[  429.477269] PERFMON: max interrupts exceeded!
[  429.479264] PERFMON: max interrupts exceeded!
[  431.514269] PERFMON: max interrupts exceeded!
[  431.516294] PERFMON: max interrupts exceeded!
[  433.557303] PERFMON: max interrupts exceeded!
[  433.558290] PERFMON: max interrupts exceeded!
[  435.585305] PERFMON: max interrupts exceeded!
[  435.586291] PERFMON: max interrupts exceeded!
[  435.620276] PERFMON: max interrupts exceeded!
[  437.619294] PERFMON: max interrupts exceeded!
[  437.620295] PERFMON: max interrupts exceeded!
[  437.621289] PERFMON: max interrupts exceeded!
[  437.622290] PERFMON: max interrupts exceeded!
[  439.637302] PERFMON: max interrupts exceeded!
[  439.638291] PERFMON: max interrupts exceeded!
[  439.645301] PERFMON: max interrupts exceeded!
[  439.646298] PERFMON: max interrupts exceeded!
[  441.684302] PERFMON: max interrupts exceeded!
[  441.685298] PERFMON: max interrupts exceeded!
[  456.974308] PERFMON: max interrupts exceeded!
[  466.542303] PERFMON: max interrupts exceeded!
[  468.924294] PERFMON: max interrupts exceeded!
[  471.246282] PERFMON: max interrupts exceeded!
[  471.257269] PERFMON: max interrupts exceeded!
[  471.258268] PERFMON: max interrupts exceeded!
[  473.295297] PERFMON: max interrupts exceeded!
[  473.296301] PERFMON: max interrupts exceeded!
[  475.312292] PERFMON: max interrupts exceeded!
[  475.323302] PERFMON: max interrupts exceeded!
[  475.324302] PERFMON: max interrupts exceeded!
[  477.346303] PERFMON: max interrupts exceeded!
[  477.347300] PERFMON: max interrupts exceeded!
[  479.381303] PERFMON: max interrupts exceeded!
[  480.685269] PERFMON: max interrupts exceeded!
[  480.686270] PERFMON: max interrupts exceeded!
[  481.405307] PERFMON: max interrupts exceeded!
[  483.425304] PERFMON: max interrupts exceeded!
[  483.426291] PERFMON: max interrupts exceeded!
[  485.461306] PERFMON: max interrupts exceeded!
[  485.462293] PERFMON: max interrupts exceeded!
[  487.499304] PERFMON: max interrupts exceeded!
[  487.500290] PERFMON: max interrupts exceeded!
[  489.524279] PERFMON: max interrupts exceeded!
[  491.546304] PERFMON: max interrupts exceeded!
[  491.547292] PERFMON: max interrupts exceeded!
[  491.548285] PERFMON: max interrupts exceeded!
[  493.581307] PERFMON: max interrupts exceeded!
[  493.582301] PERFMON: max interrupts exceeded!
[  495.605303] PERFMON: max interrupts exceeded!
[  495.606311] PERFMON: max interrupts exceeded!
[  497.641303] PERFMON: max interrupts exceeded!
[  499.665303] PERFMON: max interrupts exceeded!
[  499.666325] PERFMON: max interrupts exceeded!
[  501.699295] PERFMON: max interrupts exceeded!
[  501.700301] PERFMON: max interrupts exceeded!
[  503.715304] PERFMON: max interrupts exceeded!
[  503.716292] PERFMON: max interrupts exceeded!
[  503.717309] PERFMON: max interrupts exceeded!
[  503.725302] PERFMON: max interrupts exceeded!
[  505.748271] PERFMON: max interrupts exceeded!
[  505.749382] PERFMON: max interrupts exceeded!
[  507.782304] PERFMON: max interrupts exceeded!
[  507.783291] PERFMON: max interrupts exceeded!
[  509.804303] PERFMON: max interrupts exceeded!
[  509.805302] PERFMON: max interrupts exceeded!
[  511.840303] PERFMON: max interrupts exceeded!
[  511.841299] PERFMON: max interrupts exceeded!
[  515.565261] Uhhuh. NMI received for unknown reason 00 on CPU 1.
[  515.565261] Do you have a strange power saving mode enabled?
[  515.565261] Dazed and confused, but trying to continue
[  515.569284] PERFMON: max interrupts exceeded!
[  515.570372] PERFMON: max interrupts exceeded!
[  515.571355] PERFMON: max interrupts exceeded!
[  515.574304] PERFMON: max interrupts exceeded!
[  515.575287] PERFMON: max interrupts exceeded!
[  515.576283] PERFMON: max interrupts exceeded!
[  515.577289] PERFMON: max interrupts exceeded!
[  515.579318] PERFMON: max interrupts exceeded!
[  516.948088] __ratelimit: 113 callbacks suppressed
[  516.948118] PERFMON: max interrupts exceeded!
[  516.951315] PERFMON: max interrupts exceeded!
[  516.952298] PERFMON: max interrupts exceeded!
[  516.953315] PERFMON: max interrupts exceeded!
[  516.954406] PERFMON: max interrupts exceeded!
[  516.955390] PERFMON: max interrupts exceeded!
[  516.956336] PERFMON: max interrupts exceeded!
[  516.957277] PERFMON: max interrupts exceeded!
[  516.958285] PERFMON: max interrupts exceeded!
[  516.959313] PERFMON: max interrupts exceeded!
[  522.039265] __ratelimit: 248 callbacks suppressed
[  522.039294] PERFMON: max interrupts exceeded!
[  522.040321] PERFMON: max interrupts exceeded!
[  522.042299] PERFMON: max interrupts exceeded!
[  522.043287] PERFMON: max interrupts exceeded!
[  522.044277] PERFMON: max interrupts exceeded!
[  522.045299] PERFMON: max interrupts exceeded!
[  522.048017] PERFMON: max interrupts exceeded!
[  522.148095] PERFMON: max interrupts exceeded!
[  522.149279] PERFMON: max interrupts exceeded!
[  522.151350] PERFMON: max interrupts exceeded!
[  527.043304] __ratelimit: 1024 callbacks suppressed
[  527.043314] PERFMON: max interrupts exceeded!
[  527.044303] PERFMON: max interrupts exceeded!
[  527.045298] PERFMON: max interrupts exceeded!
[  527.046291] PERFMON: max interrupts exceeded!
[  527.047271] PERFMON: max interrupts exceeded!
[  527.048276] PERFMON: max interrupts exceeded!
[  527.049303] PERFMON: max interrupts exceeded!
[  527.052303] PERFMON: max interrupts exceeded!
[  527.053566] PERFMON: max interrupts exceeded!
[  527.054304] PERFMON: max interrupts exceeded!
[  532.049312] __ratelimit: 2191 callbacks suppressed
[  532.049321] PERFMON: max interrupts exceeded!
[  532.050303] PERFMON: max interrupts exceeded!
[  532.052298] PERFMON: max interrupts exceeded!
[  532.053305] PERFMON: max interrupts exceeded!
[  532.065291] PERFMON: max interrupts exceeded!
[  532.067263] PERFMON: max interrupts exceeded!
[  532.069299] PERFMON: max interrupts exceeded!
[  532.071300] PERFMON: max interrupts exceeded!
[  532.073311] PERFMON: max interrupts exceeded!
[  532.075302] PERFMON: max interrupts exceeded!
[  537.062306] __ratelimit: 1414 callbacks suppressed
[  537.062335] PERFMON: max interrupts exceeded!
[  537.063443] PERFMON: max interrupts exceeded!
[  537.066285] PERFMON: max interrupts exceeded!
[  537.067289] PERFMON: max interrupts exceeded!
[  537.068282] PERFMON: max interrupts exceeded!
[  537.069322] PERFMON: max interrupts exceeded!
[  537.071312] PERFMON: max interrupts exceeded!
[  537.072295] PERFMON: max interrupts exceeded!
[  537.073279] PERFMON: max interrupts exceeded!
[  537.074287] PERFMON: max interrupts exceeded!
[root@hpdv5 new]# 

--
JSR

