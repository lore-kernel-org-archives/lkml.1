Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbXL3PoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbXL3PoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXL3PoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:44:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbXL3PoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:44:11 -0500
Date: Sun, 30 Dec 2007 16:41:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Julia Lawall <julia@diku.dk>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/38] arch/x86/ia32: Use time_before, time_before_eq,
	etc.
Message-ID: <20071230154127.GA10444@elte.hu>
References: <Pine.LNX.4.64.0712241522410.23999@ask.diku.dk> <20071224153152.GA21971@one.firstfloor.org> <Pine.LNX.4.64.0712241657080.23999@ask.diku.dk> <20071230133335.GA21106@elte.hu> <Pine.LNX.4.64.0712301554430.8187@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712301554430.8187@ask.diku.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Julia Lawall <julia@diku.dk> wrote:

> > your x86 patches (#7, #8 and #9) do not include any *_eq() 
> > comparisons and they all seem to be correct. So picked those three 
> > up into x86.git - let me know if there's any breakage in them that i 
> > missed.
> 
> Only #7 is ok.  The other two have #include <jiffies.h> in the wrong 
> place.  I will send new versions of #8 and #9 shortly.

hm, #include file order in a .c file should normally not matter - why 
are they in the wrong place?

	Ingo
