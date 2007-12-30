Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbXL3QEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbXL3QEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbXL3QEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:04:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59550 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXL3QEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:04:36 -0500
Date: Sun, 30 Dec 2007 17:04:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Julia Lawall <julia@diku.dk>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/38] arch/x86/ia32: Use time_before, time_before_eq,
	etc.
Message-ID: <20071230160423.GA26221@elte.hu>
References: <Pine.LNX.4.64.0712241522410.23999@ask.diku.dk> <20071224153152.GA21971@one.firstfloor.org> <Pine.LNX.4.64.0712241657080.23999@ask.diku.dk> <20071230133335.GA21106@elte.hu> <Pine.LNX.4.64.0712301554430.8187@ask.diku.dk> <20071230154127.GA10444@elte.hu> <Pine.LNX.4.64.0712301651000.8187@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712301651000.8187@ask.diku.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Julia Lawall <julia@diku.dk> wrote:

> > hm, #include file order in a .c file should normally not matter - 
> > why are they in the wrong place?
> 
> Because they are under #ifdefs, but the code that uses the time 
> functions is not under the same #ifdef.

ah, ok - you are right. I fixed them up manually in x86.git.

	Ingo
