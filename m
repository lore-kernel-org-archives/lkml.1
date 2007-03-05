Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXCEIAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXCEIAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbXCEIAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:00:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbXCEIAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:00:38 -0500
Date: Mon, 5 Mar 2007 08:52:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@debian.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] highres: Do not run the TIMER_SOFTIRQ after switching to	highres mode
Message-ID: <20070305075205.GA19336@elte.hu>
References: <45E8E2F8.1030102@debian.org> <1172912540.24738.108.camel@localhost.localdomain> <45EAAA21.4040803@debian.org> <1173013794.24738.130.camel@localhost.localdomain> <45EAC5B1.2060306@debian.org> <20070305072518.GB14993@elte.hu> <45EBCBBE.6000001@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EBCBBE.6000001@debian.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andres Salomon <dilinger@debian.org> wrote:

> >> And an additional request, just to make it explicit that we should 
> >> not have any NO_SOFTIRQ callbacks in the tree; BUG out if we 
> >> encounter such a thing.
> > 
> > please change it to WARN_ON_ONCE()...
> > 
> > 'bug out' might mean: 'dead box'/'no resume'/'no bootup'.
>
> Certainly; note that hrtimers.c has quite a few BUG calls which could 
> render a box dead, though.

yep, bad habbit from the days when the vga console was always there to 
print stuff on.

	Ingo
