Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbXJ2WhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbXJ2WhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXJ2Wg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:36:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbXJ2Wg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:36:26 -0400
Date: Mon, 29 Oct 2007 23:36:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, --cc@redhat.com,
       avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071029223600.GA21296@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0234]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > Since it's being a tendency among paravirt clocksources to use 
> > values around 400, we should declare tsc as even better: So we use 
> > 500.
> > 
> > This patch also touches the comments on clocksource.h, which 
> > suggests that 499 would be a limit on the rating values.
> > 
> > Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
