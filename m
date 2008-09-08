Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYIHRIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYIHRIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYIHRIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:08:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYIHRIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:08:24 -0400
Date: Mon, 8 Sep 2008 19:08:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck updates for tip/kmemcheck
Message-ID: <20080908170809.GA17881@elte.hu>
References: <20080907200943.GA2665@localhost.localdomain> <20080908151753.GE10580@elte.hu> <19f34abd0809080824k4dc5e4faq777f7fb3b5fe05fe@mail.gmail.com> <19f34abd0809080826s758a212x22f17e1836e27e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0809080826s758a212x22f17e1836e27e2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Mon, Sep 8, 2008 at 5:24 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > On Mon, Sep 8, 2008 at 5:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> +#if defined(CONFIG_SMP) && !defined(CONFIG_KMEMCHECK_USE_SMP)
> >
> > Should really be just:
> >
> > +#if defined(CONFIG_SMP)
> >
> > Can you amend?
> 
> Er, also written like:
> 
> +#ifdef CONFIG_SMP
> 
> Bonk.

thx, fixed it.

	Ingo
