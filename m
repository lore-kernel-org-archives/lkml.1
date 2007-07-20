Return-Path: <linux-kernel-owner+w=401wt.eu-S935880AbXGTUpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935880AbXGTUpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXGTUpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:45:12 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:59584 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759508AbXGTUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:45:10 -0400
Date: Fri, 20 Jul 2007 16:45:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: tonyko@lineo.ca, robin.getz@analog.com, linux-kernel@vger.kernel.org
Subject: Re: blackfin - cmpxchg not atomic ?
Message-ID: <20070720204507.GA15760@Krystal>
References: <20070720202807.GA15009@Krystal> <8bd0f97a0707201336l6bed7c24i7014333ce356417f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707201336l6bed7c24i7014333ce356417f@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:44:25 up 3 days, 15:18,  3 users,  load average: 0.08, 0.39, 0.40
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Frysinger (vapier.adi@gmail.com) wrote:
> On 7/20/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> >I am currently passing through each architectures adding a
> >cmpxchg_local() to each system.h, and I notice that you disable
> >interrupts in your cmpxchg() implementation, why are you doing so ?
> 
> because Blackfin lacks any atomic instructions
> 
> >Also, does you assembly stub _really_ modify memory atomically ? If yes,
> >then there should be no need for disabling interrupts. Else, I see a
> >major problem with SMP.
> 
> that isnt the only problem with SMP on Blackfin
> 
> >I also don't like the comment in asm-blackfin/atomic.h :
> >
> > * Generally we do not concern about SMP BFIN systems, so we don't have
> > * to deal with that.
> >
> >I have seen on the blackfin website that you actually sell a board with
> >SMP. Why aren't you caring about it ?
> 
> just because a processor has more than one core does not make it SMP
> -mike

I see, thanks for the reply. Is there a particular reason for
implementing system.h/cmpxchg() in assembly rather that in plain C then?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
