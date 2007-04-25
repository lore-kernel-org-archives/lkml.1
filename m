Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXDYJ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXDYJ3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992452AbXDYJ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:29:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXDYJ3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:29:52 -0400
Date: Wed, 25 Apr 2007 11:29:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rogan Dawes <lists@dawes.za.net>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Peter Williams <pwil3058@bigpond.net.au>,
       ck list <ck@vds.kolivas.org>, Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425092919.GB498@elte.hu>
References: <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu> <462DAC06.9040309@dawes.za.net> <20070424073103.GA29054@elte.hu> <462DBEF6.70205@dawes.za.net> <462E1C2E.30406@nortel.com> <462E1D37.3060008@dawes.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462E1D37.3060008@dawes.za.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rogan Dawes <lists@dawes.za.net> wrote:

> My concern was that since Ingo said that this is a closed economy, 
> with a fixed sum/total, if we lose a nanosecond here and there, 
> eventually we'll lose them all.

it's not a closed economy - the CPU constantly produces a resource: "CPU 
cycles to be spent", and tasks constantly consume that resource. So in 
that sense small inaccuracies are not a huge issue. But you are correct 
that each and every such inaccuracy has to be justified. For example 
larger inaccuracies on the order of SCHED_LOAD_SCALE are a problem 
because they can indeed sum up, and i fixed up a couple of such 
inaccuracies in -v6-to-be.

	Ingo
