Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZBVSTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZBVSTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 13:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZBVSTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 13:19:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51951 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZBVSTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 13:19:02 -0500
Date: Sun, 22 Feb 2009 19:18:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/2] Rework disabling of interrupts during
	suspend-resume
Message-ID: <20090222181841.GA17895@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902221007150.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902221007150.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING, IRQF_TIMER,
> +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL, IRQF_TIMER,
> +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL, IRQF_TIMER,

s/, IRQF_TIMER/ | IRQF_TIMER

i guess.

	Ingo
