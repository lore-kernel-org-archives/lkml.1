Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXDDVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXDDVer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXDDVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:34:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39245 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXDDVep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:34:45 -0400
Date: Wed, 4 Apr 2007 23:34:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm tree
Message-ID: <20070404213404.GA21742@elte.hu>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net> <1175417035.28263.42.camel@localhost.localdomain> <1175704712.15973.35.camel@imap.mvista.com> <20070404125853.1cf9b7b7.akpm@linux-foundation.org> <1175717425.15973.61.camel@imap.mvista.com> <20070404203647.GA12563@elte.hu> <1175719489.15973.66.camel@imap.mvista.com> <20070404211514.GA18600@elte.hu> <1175722246.15973.78.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175722246.15973.78.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> > but why do you call that a simplification? Remove 5 lines of code 
> > from the generic code, by adding +1 line to every clocksource 
> > driver, totalling to like +20 lines at the moment?
> 
> I guess I don't look at it in terms of lines .. Why do you think 
> reciting a line count diminishes the "simplification" claim? The 20+ 
> lines that I added to each clocksource don't have a size or runtime 
> effect ..

but they have a robustness and maintainability effect. Key is to keep 
drivers _simple_ and hard to mess up. If it's 5 extra lines of code to 
simplify a driver then we just do it. This is maintainance 101.

i cannot believe you are still arguing this. I explained this to you 
many weeks ago!

	Ingo
