Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYBYLRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYBYLRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYBYLR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:17:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41459 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYBYLR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:17:26 -0500
Date: Mon, 25 Feb 2008 12:17:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225111707.GA7062@elte.hu>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225110858.GA32450@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> What I want is that e.g. after fiddling with kernel headers I want an 
> easy way of having much compile coverage. And my script that builds 
> all defconfig's is trivial (although it takes a day to finish).

no, i think you misunderstood me. I do allyesconfig testing to make sure 
the kernel is still generic enough on PC hardware - not to catch build 
breakage.

What i do against build breakage is randconfig testing. That catches far 
more build breakage than a few limited number of defconfigs would ever.

More defconfigs would just be a constant maintenance drag, they are 
rather pointless on PC hardware anyway (we'd have to have at least a few 
hundred of them for it to be meaningful as a "default config") and it 
does not really solve the problem either.

	Ingo
