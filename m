Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZFQR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZFQR0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZFQR0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:26:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbZFQR0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:26:13 -0400
Date: Wed, 17 Jun 2009 19:26:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090617172601.GA3493@elte.hu>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost> <1245253102.6067.94.camel@jstultz-laptop> <20090617172325.GA32332@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617172325.GA32332@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miroslav Lichvar <mlichvar@redhat.com> wrote:

> Still, I'd really like to see the original behavior restored. Most 
> of the users complaining about slow convergence are probably just 
> hitting the calibration problem, which needs to be fixed by other 
> means than making PLL faster. Also, users of other systems seem to 
> be happy with their slow convergence. At least that's the 
> impression I have from NTP lists.

Wouldnt the goal be to calibrate as fast as possible? (Without any 
bad oscillation)

	Ingo
