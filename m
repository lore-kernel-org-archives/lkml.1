Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZJAVvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZJAVvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZJAVv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:51:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:53273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZJAVvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:51:25 -0400
Date: Thu, 1 Oct 2009 09:18:58 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20091001091858.411d8df0@infradead.org>
In-Reply-To: <20090930203818.GA24070@elte.hu>
References: <4AC10365.7090802@gmail.com>
	<4AC2712C.4080901@gmail.com>
	<alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
	<20090929232248.735bf4df@infradead.org>
	<alpine.LFD.2.01.0909291429570.6996@localhost.localdomain>
	<20090930170754.0886ff2e@infradead.org>
	<20090930193204.GA16350@elte.hu>
	<4AC3BC89.2050404@gmail.com>
	<alpine.LFD.2.01.0909301320300.6996@localhost.localdomain>
	<20090930202233.GA21890@elte.hu>
	<20090930203818.GA24070@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 22:38:18 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > > > probably a "memory" clobber is needed, alternative_io() doesnt
> > > > provide it.
> > > 
> > > Yeah, good catch.
> > 
> > Yeah - i'm testing this right now, it looks like something that
> > could explain the hang.
> 
> Yeah - that was the cause of the hang

I woke up at 2am realizing that this was missing.. but you beat me to
it ;)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
