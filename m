Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbXCFMxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbXCFMxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933870AbXCFMxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:53:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933840AbXCFMxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:53:10 -0500
Date: Tue, 6 Mar 2007 13:51:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306125119.GA6119@elte.hu>
References: <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu> <20070306104618.GA5792@mellanox.co.il> <1173180977.9161.14.camel@localhost> <20070306120701.GA29599@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306120701.GA29599@elte.hu>
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

* Ingo Molnar <mingo@elte.hu> wrote:

> > > BTW, Ingo, can you suspend/resume any number of times with this 
> > > patch?
> > 
> > well I could at least two times in a row in my minimalistic setup 
> > (config attached) however using the full kernel config it still 
> > hangs ... (config also attached in case you watn to compare it).
> 
> i can confirm that with your full config i see a hang too. This is 
> most likely the ACPI problem - we are debugging this now and will come 
> up with a patch.

update: this only happens with simulation, and even then it's not a full 
hang but 'hangs until i hit a key'. With real resume i'm hitting a real 
key anyway so it doesnt hang.

	Ingo
