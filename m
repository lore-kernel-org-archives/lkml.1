Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZALMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZALMeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZALMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:34:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZALMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:34:02 -0500
Date: Mon, 12 Jan 2009 13:33:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@suse.cz>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       shaohua.li@intel.com
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
Message-ID: <20090112123349.GD29628@elte.hu>
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com> <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com> <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain> <20081204111621.GA2466@elf.ucw.cz> <a4423d670901120240m6ee29951ucc1c0f16c27d398c@mail.gmail.com> <1231761143.4371.0.camel@laptop> <20090112115934.GA24266@elte.hu> <a4423d670901120427q502ae9b6uded2e55a91c2a7cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670901120427q502ae9b6uded2e55a91c2a7cc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2188]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> 2009/1/12 Ingo Molnar <mingo@elte.hu>:
> >
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> > > (No, introducing WARN_ON()s is not fine; it spams kerneloops.org at
> >> > > least...)
> >> >
> >> > The warning is still here on 2.6.29-rc1. It taints the kernel.
> >>
> >> Does this fix it?
> Yes, it does. Thanks Peter.

thanks - added your Tested-by tag to the commit too.

	Ingo
