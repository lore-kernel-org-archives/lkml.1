Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYK0MEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYK0MEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYK0ME1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:04:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbYK0ME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:04:26 -0500
Date: Thu, 27 Nov 2008 13:04:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: entry_64.S - use ENTRY to define child_rip
Message-ID: <20081127120410.GC4259@elte.hu>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <1227782223.31044.1287040549@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227782223.31044.1287040549@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> 
> On Wed, 26 Nov 2008 22:17:00 +0300, gorcunov@gmail.com said:
> > From: Cyrill Gorcunov <gorcunov@gmail.com>
> > 
> > child_rip is called not by its name but indirectly
> > rather so make it global and aligned.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> >  arch/x86/kernel/entry_64.S |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 64688db..098ba0b 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1322,7 +1322,7 @@ ENTRY(kernel_thread)
> >  	CFI_ENDPROC
> >  END(kernel_thread)
> >  
> > -child_rip:
> > +ENTRY(child_rip)
> >  	pushq $0		# fake return address
> >  	CFI_STARTPROC
> >  	/*
> 
> Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

applied to tip/x86/irq, thanks!

	Ingo
