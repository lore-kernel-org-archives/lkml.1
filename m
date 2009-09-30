Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZI3QNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZI3QNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZI3QNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:13:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:42667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZI3QNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:13:46 -0400
Date: Wed, 30 Sep 2009 18:13:57 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090930181357.637bf8ec@infradead.org>
In-Reply-To: <4AC37FE5.7020200@gmail.com>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	<4AC060AE.1090401@gmail.com>
	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
	<20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
	<4AC10365.7090802@gmail.com>
	<4AC2712C.4080901@gmail.com>
	<alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
	<20090929232248.735bf4df@infradead.org>
	<alpine.LFD.2.01.0909291429570.6996@localhost.localdomain>
	<20090930170754.0886ff2e@infradead.org>
	<4AC37FE5.7020200@gmail.com>
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

On Wed, 30 Sep 2009 17:57:25 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> Note:
> 
> lock; cmpxchg8b (%%esi)
> 
> gives 4 bytes opcode : f0 0f c7 0e
> Because alternative (call cmpxchg8b_emu) uses 5 bytes, a nop will be
> added.
> 
> Choosing ".byte 0xf0, 0x0f, 0xc7, 0x4e, 0x00"  aka "lock cmpxchg8b
> 0x0(%esi)" is a litle bit better ?

doesn't matter normally.. nops fall out quickly in the execution path ;)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
