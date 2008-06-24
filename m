Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbYFXLyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbYFXLyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYFXLyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:54:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYFXLyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:54:15 -0400
Date: Tue, 24 Jun 2008 13:54:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080624115400.GF21890@elte.hu>
References: <20080603182014.79a38d03@infradead.org> <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com> <20080604061637.6bab3f67@infradead.org> <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080620113922.GG7439@elte.hu> <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080623232149.GA22926@elte.hu> <1214264070.3882.22.camel@promb-2n-dhcp368.eng.vmware.com> <20080623234728.GA17297@elte.hu> <1214270516.3882.39.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214270516.3882.39.camel@promb-2n-dhcp368.eng.vmware.com>
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


* Alok Kataria <akataria@vmware.com> wrote:

> On Mon, 2008-06-23 at 16:47 -0700, Ingo Molnar wrote:
> > * Alok Kataria <akataria@vmware.com> wrote:
> > 
> > > IMO, lpj_tsc explains how is this variable initialized. But thinking
> > > about it, maybe we should rename it to "lpj_timer" ?
> > 
> > ok. But instead of 'lpj_timer' i'd suggest to use something like
> > 'lpj_fine' - as this really is about finegrained measurements.
> 
> Ok.
> > 
> > I'd suggest a delta patch against tip/master that renames all those
> > tsc_* variables to fine_*. So tsc_rate_min would become fine_rate_min,
> > etc.
> 
> Ingo, tsc_rate_min etc are related to the timer rate so calling it 
> fine_rate_min would be confusing IMO. Instead i call it as 
> timer_rate_min. Below is the patch on tip/master. Tested on both 32 
> and 64 bit environment, tree works fine for me.

applied to tip/x86/delay - thanks Alok.

	Ingo
