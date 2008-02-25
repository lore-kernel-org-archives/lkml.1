Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYBYKy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYBYKy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYBYKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:54:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbYBYKyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:54:19 -0500
Date: Mon, 25 Feb 2008 11:54:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH][x86] rdc321x: remove watchdog file
Message-ID: <20080225105408.GB5648@elte.hu>
References: <200802251144.08962.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802251144.08962.florian.fainelli@telecomint.eu>
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

> This driver should be moved to drivers/watchdog so let's remove the 
> arch/x86/mach-rdc321x/wdt.c file.

thanks, applied. I guess i should push this change upstream only once 
the new watchdog driver has been committed to drivers/watchdog/ ?

(If that's a completely new driver then please Cc: me to the driver 
submission so that i can track that trigger condition properly.)

	Ingo
