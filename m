Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZI3RKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZI3RKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZI3RKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:10:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbZI3RKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:10:22 -0400
Date: Wed, 30 Sep 2009 10:08:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Arjan van de Ven <arjan@infradead.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
In-Reply-To: <4AC38D7A.7030407@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.2.01.0909301007410.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com>
 <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org>
 <4AC38D7A.7030407@s5r6.in-berlin.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, Stefan Richter wrote:
> 
> As long as it can't be turned into an atomic access, shouldn't cmpxchg64
> be hidden from the common kernel coder?  Almost everybody will assume
> that it is an atomic operation and happily use it in unsafe places.

But it _is_ atomic. We don't support SMP on the platforms that we have to 
do it with emulation on.

There's a theoretical problem with NMI, but it's not one we can solve or 
that is really all that interesting, so might as well ignore it.

		Linus
