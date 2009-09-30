Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZI3Rla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZI3Rla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZI3Rl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:41:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59071 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZI3Rl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:41:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AC397FE.8060001@s5r6.in-berlin.de>
Date: Wed, 30 Sep 2009 19:40:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC38D7A.7030407@s5r6.in-berlin.de> <alpine.LFD.2.01.0909301007410.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909301007410.6996@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 30 Sep 2009, Stefan Richter wrote:
>> As long as it can't be turned into an atomic access, shouldn't cmpxchg64
>> be hidden from the common kernel coder?  Almost everybody will assume
>> that it is an atomic operation and happily use it in unsafe places.
> 
> But it _is_ atomic. We don't support SMP on the platforms that we have to 
> do it with emulation on.
> 
> There's a theoretical problem with NMI, but it's not one we can solve or 
> that is really all that interesting, so might as well ignore it.

Ah, right, I could have taken a hint from /* disable interrupts */ in
Arjan's cmpxchg8b_emu.
-- 
Stefan Richter
-=====-==--= =--= ====-
http://arcgraph.de/sr/
