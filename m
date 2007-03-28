Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbXC1SgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbXC1SgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965624AbXC1SgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:36:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbXC1SgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:36:08 -0400
X-Greylist: delayed 13929 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 14:36:08 EDT
Date: Wed, 28 Mar 2007 20:32:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Maxim <maximlevitsky@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Message-ID: <20070328183226.GA16415@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com> <1175065468.4017.1.camel@chaos> <200703281543.47049.maximlevitsky@gmail.com> <20070328180457.GA4253@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328180457.GA4253@mellanox.co.il>
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


* Michael S. Tsirkin <mst@dev.mellanox.co.il> wrote:

> Bingo!
> 
> The patch below fixes the two problems (listed above) with resume from 
> RAM that I have observed on my T60 with 2.6.21-rc5: with this patch 
> applied, and with CONFIG_NO_HZ unset, date advances correctly, X 
> functions properly and there is no delay on first disk access.
> 
> Thanks very much.
[...]
> 
> Maxim, do you plan to send this upstream?

we'll fix this the right way tomorrow, by adding a proper suspend/resume 
sysdev handler - the lapic clockevents driver already has that. Maxim 
definitely deserves alot of kudos for having found this bug!

	Ingo
