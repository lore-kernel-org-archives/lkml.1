Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYBYKvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYBYKvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYBYKvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:51:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbYBYKva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:51:30 -0500
Date: Mon, 25 Feb 2008 11:51:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225105110.GA5648@elte.hu>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <200802251124.17561.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802251124.17561.florian.fainelli@telecomint.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> > In fact for rdc321x that should be rather easy to do right now: 
> > wdt.c could/should become a regular watchdog driver, and do we 
> > really need those GPIO specials in include/asm-x86/mach-rdc321x/ ? I 
> > believe it should be possible to boot CONFIG_X86_GENERICARCH on a 
> > rdc321x. Am i missing any particular complication?
> 
> The GPIO calls will be moving later when I have finished the gpiolib 
> integration for RDC just like what is currently done for ARM. You are 
> right for the watchdog driver, I will move it right now.

ok, great! Btw., do you think you could achieve your board to boot fine 
with CONFIG_X86_GENERICARCH=y and CONFIG_M486=y?

	Ingo
