Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYGNQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYGNQqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYGNQqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:46:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32913 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYGNQqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:46:07 -0400
Date: Mon, 14 Jul 2008 18:45:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Message-ID: <20080714164548.GA28499@elte.hu>
References: <12155255883170-git-send-email-od@suse.de> <20080713210133.GA12362@elte.hu> <200807140924.59023.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807140924.59023.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > applied to tip/x86/pci-ioapic-boot-irq-quirks, thanks Olaf.
> >
> > Jesse, what do you think about this topic? We are keeping it 
> > separate for the time being. They are not particularly pretty, but 
> > being able to mask/unmask irqs (without generating those legacy IRQs 
> > and creating an IRQ storm) is essential to -rt.
> 
> See my other reply; the branch looks good.  I agree that making sure 
> -rt can work is an important feature.  My only concern is that this is 
> touching so much hardware specific code that *something* is likely to 
> break.  But as long as Olaf & co. can help track down any issues, I'm 
> ok with it.

ok. We'll cook it a bit more in tip/master and then send it over to you 
once all the dependent changes have gone upstream in the merge window, 
ok? I think it's v2.6.27 worthy stuff - nicely localized, sufficiently 
finegrained and any problems with it has to be debugged the hard way by 
exposing people to them ...

	Ingo
