Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYFDDAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYFDDAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYFDC7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:59:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57711 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYFDC7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:59:54 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5309"; a="3486852"
Message-ID: <4846053C.3090201@qualcomm.com>
Date: Tue, 03 Jun 2008 20:00:12 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Oeser <ioe-lkml@rameria.de>, Dimitri Sivanich <sivanich@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <4844BB41.7000605@qualcomm.com> <4845D825.6000403@qualcomm.com> <200806041118.40675.nickpiggin@yahoo.com.au>
In-Reply-To: <200806041118.40675.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nick Piggin wrote:
> On Wednesday 04 June 2008 09:47, Max Krasnyanskiy wrote:
 >> Dimitri, you can probably use that too. ie Boot the thing with most CPUs
>> offline and then bring them online. That way you'll know for sure that no
>> timers, works, hard-/soft-irqs, etc are running on them.
> 
> When you bring a CPU online, in theory the sched domains should get
> set up for them, so you should start seeing processes get migrated
> onto it, and with them timers work queues etc.
> 
> If you have irqbalanced running, it probably migrates irqs onto them
> as well if it needs to.

Sure. My suggestion assumes that system wide balancing is disabled (via top
level cpuset) and that IRQ affinity masks are properly setup. I mentioned that
in my earlier emails.

Max
