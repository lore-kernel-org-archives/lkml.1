Return-Path: <linux-kernel-owner+w=401wt.eu-S933979AbXC0FS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbXC0FS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933983AbXC0FS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:18:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:50006 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979AbXC0FS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:18:26 -0400
Subject: Re: [PATCH] genirq: do not mask interrupts by default
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <1174972037.5329.5.camel@localhost.localdomain>
References: <200702161759.l1GHxsO8010669@hera.kernel.org>
	 <1174972037.5329.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 15:18:05 +1000
Message-Id: <1174972685.5329.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I missed that one ... thanks for not telling/CC'ing me and not fixing
> powerpc :-( (I know, everybody is supposed to have the bandwidth to read
> all of lkml... I don't).
> 
> We need to audit all of our PICs to make sure they can deal with
> disabling an already ack'ed interrupt, which isn't clear.. in fact, that
> might cause some to lose it when re-enabling later on. This is a major
> semantic change and now I just discover it while we are at -rc5 !
> 
> I'm concerned that quite a few PICs will not re-emit the interrupt once
> re-enabled.

Note that I'm not opposed to the change at all, I think it's a good
idea, I'm just worried I'm discovering it a bit late and I've seen PICs
broken in some many colorful ways that I'm a bit worried... Oh well...

Ben.


