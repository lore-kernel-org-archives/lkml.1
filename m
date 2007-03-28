Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbXC1OoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbXC1OoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXC1OoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:44:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbXC1OoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:44:00 -0400
Date: Wed, 28 Mar 2007 16:41:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Maxim <maximlevitsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Message-ID: <20070328144148.GA16244@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com> <1175065468.4017.1.camel@chaos> <200703281543.47049.maximlevitsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703281543.47049.maximlevitsky@gmail.com>
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


* Maxim <maximlevitsky@gmail.com> wrote:

> I almost sure I know why this happens,

cool! Your patch is a definite improvement on my t60 (where 
suspend/resume never worked with hpet enabled). But it does not fix 
everything - for example the timings are way off after resume. Thomas?

	Ingo
