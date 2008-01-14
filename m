Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYANTAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYANTAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYANTAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:00:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYANTAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:00:17 -0500
Date: Mon, 14 Jan 2008 20:00:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault III
Message-ID: <20080114190004.GB26540@elte.hu>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478B9183.3020101@goop.org> <20080114165635.GK15542@elte.hu> <20080114170856.GA18412@one.firstfloor.org> <20080114171838.GA18662@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114171838.GA18662@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> BTW there seems to be some other instability that hits even on 64bit. 
> Since I updated my workstation to a recent git-x86 based kernel 
> (admittedly with my patches too) I had at least one hard hang already.
> 
> Previously it ran an older -rc5 based kernel without git-x86 also with 
> most of my patches and was stable for >23 days until a KVM oops 
> required a reboot.
> 
> It unfortunately was not set up to receive console at this point and 
> it hung in X, but I'm watching it now.

hm. Did the hanging kernel have the i387 regset fix from Roland already? 
That bug indeed manifested itself as rare desktop hangs.

other than that i know of no pending instability but the large-RAM 
bootup crash you reported.

	Ingo
