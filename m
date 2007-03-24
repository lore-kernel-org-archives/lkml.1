Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbXCXWd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbXCXWd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 18:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbXCXWd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 18:33:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbXCXWd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 18:33:26 -0400
Date: Sat, 24 Mar 2007 23:32:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] i386: Prevent early access to TSC to avoid crash on TSCless systems
Message-ID: <20070324223243.GA30060@elte.hu>
References: <1174773769.10840.450.camel@localhost.localdomain> <3d8471ca0703241530x79149b20sfb146fd77188c342@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0703241530x79149b20sfb146fd77188c342@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> >+static int tsc_enabled;
> 
> So, now we have tsc_disable, tsc_enabled and tsc_unstable. I can 
> understand the latter, but this lacks orthogonality IMHO.

tsc_disable should be renamed to tsc_disable_override or so, to signal 
that it's only the mirror of the 'notsc' flag the user passed in over 
the boot line.

	Ingo
