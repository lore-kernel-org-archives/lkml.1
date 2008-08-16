Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbYHPPT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbYHPPT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 11:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYHPPTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 11:19:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56112 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYHPPTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 11:19:17 -0400
Date: Sat, 16 Aug 2008 17:19:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT PULL] new shot at time.c integration
Message-ID: <20080816151900.GA27040@elte.hu>
References: <200808151625.m7FGP3Gn027609@int-mx1.corp.redhat.com> <20080815165134.GB29956@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815165134.GB29956@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Ingo, please pull the latest master git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> > 
> > into your tree
> > 
> > It is based on your tip/master branch.
> 
> thanks, i've pulled it and rebased it to -git - as that's the best 
> base this early in the cycle. I've pushed out the result into 
> tip/x86/time - havent integrated it into tip/master yet.

have just tried a test-merge, and got a few crashes during -tip testing. 
One is a hard lockup during bootup, with this config:

  http://redhat.com/~mingo/misc/config-Sat_Aug_16_16_49_05_CEST_2008.bad

no console output. I've pushed out this integrated tree into 
tip/x86/time.broken: note that i had to do a few manual merges due to 
the io_apic.c unification - maybe that interacted.

there's a 32-bit failure as well:

  http://redhat.com/~mingo/misc/config-Sat_Aug_16_15_51_57_CEST_2008.bad

i dont know anything about that, other that it didnt boot up after 
x86/time integration.

	Ingo
