Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXCFKjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXCFKjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXCFKjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:39:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbXCFKjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:39:11 -0500
Date: Tue, 6 Mar 2007 11:37:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Soeren Sonnenburg <kernel@nn7.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306103712.GA10942@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain> <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> <20070306103315.GA4295@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306103315.GA4295@mellanox.co.il>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > Quoting Linus Torvalds <torvalds@linux-foundation.org>:
> >
> > Ok, it does indeed solve the problem for me.
> 
> Not yet for me unfortunately, although this seems to help.
> Is this the patch I should have applied?
> http://lkml.org/lkml/2007/3/5/445
> 
> With this applied, on resume I get *some* screen output soon after 
> resume (e.g. with s2ram I get several characters on VGA, X starts 
> drawing some windows) but then the crescent symbol starts blinking 
> again and the system hangs.

could you try this via s2ram on a text console, to see whether the 
kernel spits out any warning before it locks up?

	Ingo
