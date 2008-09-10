Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYIJJbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYIJJbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYIJJbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:31:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYIJJba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:31:30 -0400
Date: Wed, 10 Sep 2008 11:31:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Message-ID: <20080910093105.GA5259@elte.hu>
References: <20080909184615.GA7303@lenovo> <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com> <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com> <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Tue, Sep 9, 2008 at 11:02 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Wed, Sep 10, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > ...
> >>
> >> hope we can keep using MACRO..
> >>
> >> YH
> >>
> >
> > Btw, Yinghai, what does it mean? To not touch this macro at all?
> > Or you mean about implementation issue (ie the design itself)?
> 
> do not touch this macro... and may revisit after 2.6.28

anything you are particularly worried about? Regressions we should be 
able to find pretty quickly, in a central macro like that - and the 
macro is quite ugly.

	Ingo
