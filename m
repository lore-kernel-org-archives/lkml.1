Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbZCQTCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbZCQTCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbZCQTBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:01:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:1079 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbZCQTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:01:53 -0400
MIME-Version: 1.0
In-Reply-To: <49BFEF01.1060703@hp.com>
References: <20090317013220.GA22474@Krystal> <49BFEF01.1060703@hp.com>
Date: Wed, 18 Mar 2009 02:01:51 +0700
Message-ID: <d0cc17060903171201o49af0bcbr33d17e83c4996edb@mail.gmail.com>
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
From: Andika Triwidada <andika@startrek.or.id>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older IA-64

processor  : 3
vendor     : GenuineIntel
arch       : IA-64
family     : 32
model      : 0
model name : Intel(r) Itanium(r) 2 Processor 1.6GHz with 18M L3 Cache
for 533MHz Platforms
revision   : 7
archrev    : 0
features   : branchlong, 16-byte atomic ops
cpu number : 0
cpu regs   : 4
cpu MHz    : 1594.911
itc MHz    : 399.226174
BogoMIPS   : 3186.68
siblings   : 2
physical id: 1
core id    : 1
thread id  : 0

test init
test results: time for baseline
number of loops: 20000
total time: 10003
-> baseline takes 0 cycles
test end
test results: time for locked cmpxchg
number of loops: 20000
total time: 60073
-> locked cmpxchg takes 3 cycles
test end
test results: time for non locked cmpxchg
number of loops: 20000
total time: 60014
-> non locked cmpxchg takes 3 cycles
test end
test results: time for locked add return
number of loops: 20000
total time: 150007
-> locked add return takes 7 cycles
test end
test results: time for non locked add return
number of loops: 20000
total time: 150009
-> non locked add return takes 7 cycles
test end
test results: time for enabling interrupts (STI)
number of loops: 20000
total time: 45003
-> enabling interrupts (STI) takes 2 cycles
test end
test results: time for disabling interrupts (CLI)
number of loops: 20000
total time: 59999
-> disabling interrupts (CLI) takes 2 cycles
test end
test results: time for disabling/enabling interrupts (STI/CLI)
number of loops: 20000
total time: 105001
-> enabling/disabling interrupts (STI/CLI) takes 5 cycles
test end
