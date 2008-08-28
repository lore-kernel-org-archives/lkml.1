Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbYH1U7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbYH1U7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbYH1U6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:58:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39254 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbYH1U6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:58:46 -0400
Date: Thu, 28 Aug 2008 22:58:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Witbrodt <dawitbro@sbcglobal.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
Message-ID: <20080828205828.GA28383@elte.hu>
References: <1219955655-18357-1-git-send-email-yhlu.kernel@gmail.com> <alpine.LFD.1.10.0808281339250.3300@nehalem.linux-foundation.org> <86802c440808281352y1371f437vf3409d9e104d1a51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808281352y1371f437vf3409d9e104d1a51@mail.gmail.com>
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

> On Thu, Aug 28, 2008 at 1:40 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Thu, 28 Aug 2008, Yinghai Lu wrote:
> >>
> >> v2: insert e820 reserve resources before pnp_system_init
> >
> > Looks ok by me. Now it just needs testing ;)
> >
> > Does it actually fix the HPET regression on that odd machine (without the
> > special hacks to recognize HPET explicitly)?
> >
> 
> David,
> 
> can you test attached patch?
> also you may try to revert the old patch.

great - i've done the revert of a2bd7274b471 and have applied your patch 
and pushed it out into -tip. David, could you please test whether 
tip/master works for you out of box?

	Ingo
