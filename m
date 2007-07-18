Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbXGRNaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbXGRNaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbXGRNaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:30:05 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4889 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759138AbXGRNaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:30:04 -0400
Date: Wed, 18 Jul 2007 15:26:31 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <1184763148.20032.135.camel@twins>
Message-ID: <Pine.LNX.4.64.0707181510590.1817@scrub.home>
References: <20070711211638.GE18767@one.firstfloor.org>  <20070711214649.GK14435@v2.random>
  <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0707130415520.1818@scrub.home>  <1184302024.6709.11.camel@Homer.simpson.net>
  <Pine.LNX.4.64.0707131728070.1817@scrub.home>  <1184355835.12353.321.camel@chaos>
 <469B0D9E.3030402@andrew.cmu.edu>  <20070716070610.GA10907@elte.hu> 
 <Pine.LNX.4.64.0707161213500.1817@scrub.home>  <20070716112037.GA6895@elte.hu>
  <Pine.LNX.4.64.0707161331570.1817@scrub.home> 
 <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org> 
 <1184754430.20032.130.camel@twins>  <Pine.LNX.4.64.0707181442340.1817@scrub.home>
 <1184763148.20032.135.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 18 Jul 2007, Peter Zijlstra wrote:

> By breaking the UNIX model of nice levels. Not an option in my book.

BTW what is the "UNIX model of nice levels"?

SUS specifies the limit via NZERO, which is defined as "Minimum Acceptable 
Value: 20", I can't find any information that it must be 20.

bye, Roman
