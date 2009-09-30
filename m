Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZI3Q4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZI3Q4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZI3Q4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:56:21 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41913 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZI3Q4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:56:20 -0400
Message-ID: <4AC38D7A.7030407@s5r6.in-berlin.de>
Date: Wed, 30 Sep 2009 18:55:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>	<4AC060AE.1090401@gmail.com>	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>	<20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>	<4AC10365.7090802@gmail.com>	<4AC2712C.4080901@gmail.com>	<alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>	<20090929232248.735bf4df@infradead.org>	<alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org>
In-Reply-To: <20090930170754.0886ff2e@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Subject: [PATCH] x86: Provide an alternative() based cmpxchg64()
> 
> Based on Linus' patch, this patch provides cmpxchg64() using
> the alternative() infrastructure.
> 
> Note: the fallback is NOT smp safe, just like the current fallback
> is not SMP safe.

As long as it can't be turned into an atomic access, shouldn't cmpxchg64
be hidden from the common kernel coder?  Almost everybody will assume
that it is an atomic operation and happily use it in unsafe places.
-- 
Stefan Richter
-=====-==--= =--= ====-
http://arcgraph.de/sr/
