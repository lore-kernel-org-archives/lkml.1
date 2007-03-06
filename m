Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbXCFJHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbXCFJHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXCFJHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:07:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152AbXCFJHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:07:17 -0500
Date: Tue, 6 Mar 2007 10:06:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
Message-ID: <20070306090612.GA25791@elte.hu>
References: <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz> <20070305084257.GA4464@mellanox.co.il> <20070305101120.GA23032@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305101120.GA23032@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> with real resume it takes even longer time - but i dont see where the 
> delays come from in that case - i suspect it's SATA.

update: Thomas' PIT/HPET resume-fix patch fixed the delay for me.

	Ingo
