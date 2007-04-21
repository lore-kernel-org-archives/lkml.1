Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXDUTB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXDUTB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXDUTBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:01:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34019 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbXDUTBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:01:25 -0400
Date: Sat, 21 Apr 2007 21:00:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Con Kolivas <kernel@kolivas.org>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421190026.GA25720@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr>
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


* Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> > i've attached it below in a standalone form, feel free to put it 
> > into SD! :)
> 
> Assume X went crazy (lacking any statistics, I make the unproven 
> statement that this happens more often than kthreads going berserk), 
> then having it niced with minus something is not too nice.

i've not experienced a 'runaway X' personally, at most it would crash or 
lock up ;) The value is boot-time and sysctl configurable as well back 
to 0.

	Ingo
