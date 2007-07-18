Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbXGRNcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbXGRNcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbXGRNcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:32:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38850 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610AbXGRNcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:32:05 -0400
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <Pine.LNX.4.64.0707181510590.1817@scrub.home>
References: <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
	 <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu>
	 <20070716070610.GA10907@elte.hu>
	 <Pine.LNX.4.64.0707161213500.1817@scrub.home>
	 <20070716112037.GA6895@elte.hu>
	 <Pine.LNX.4.64.0707161331570.1817@scrub.home>
	 <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
	 <1184754430.20032.130.camel@twins>
	 <Pine.LNX.4.64.0707181442340.1817@scrub.home>
	 <1184763148.20032.135.camel@twins>
	 <Pine.LNX.4.64.0707181510590.1817@scrub.home>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 15:31:20 +0200
Message-Id: <1184765480.20032.144.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 15:26 +0200, Roman Zippel wrote:
> Hi,
> 
> On Wed, 18 Jul 2007, Peter Zijlstra wrote:
> 
> > By breaking the UNIX model of nice levels. Not an option in my book.
> 
> BTW what is the "UNIX model of nice levels"?
> 
> SUS specifies the limit via NZERO, which is defined as "Minimum Acceptable 
> Value: 20", I can't find any information that it must be 20.

I have never encountered a UNIX where it is anything other than 20.
Convention (alas not specification) does dictate 20.

