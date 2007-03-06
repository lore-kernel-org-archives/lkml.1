Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXCFNEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXCFNEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXCFNEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:04:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXCFNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:04:45 -0500
Date: Tue, 6 Mar 2007 14:03:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306130331.GA9031@elte.hu>
References: <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu> <20070306104618.GA5792@mellanox.co.il> <1173180977.9161.14.camel@localhost> <20070306120701.GA29599@elte.hu> <20070306125119.GA6119@elte.hu> <20070306125530.GA6981@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306125530.GA6981@mellanox.co.il>
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


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > update: this only happens with simulation, and even then it's not a 
> > full hang but 'hangs until i hit a key'. With real resume i'm 
> > hitting a real key anyway so it doesnt hang.
> 
> How 'bout my .config?

your config works fine here too - did full suspend/resume twice without 
any problems. Maybe it's the ACPI related regression Thomas is seeing.

	Ingo
