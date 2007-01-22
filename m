Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXAVUAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXAVUAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXAVUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:00:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXAVUA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:00:28 -0500
Date: Mon, 22 Jan 2007 20:59:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH query] arm: i.MX/MX1 clock event source
Message-ID: <20070122195924.GD21277@elte.hu>
References: <200701210101.27345.pisa@cmp.felk.cvut.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701210101.27345.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4809]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:

> Hello Thomas, Sascha and Ingo
> 
> please can you find some time to review next patch
>   arm: i.MX/MX1 clock event source
> which has been sent to you and to the ALKML at 2007-01-13.
> 
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/29510/focus=29533
> 
> There seems to be some problems, because this patch has not been 
> accepted to patch-2.6.20-rc5-rt7.patch, but GENERIC_CLOCKEVENTS are 
> set already for i.MX and this results in a problems to run RT kernel 
> on this architecture.

i've added your patch to -rt, but note that there's a new, slightly 
incompatible clockevents code in -rt now so you'll need to do some more 
(hopefully trivial) fixups for this to build and work.

	Ingo
