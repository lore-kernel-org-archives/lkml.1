Return-Path: <linux-kernel-owner+w=401wt.eu-S1765901AbXLNK55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765901AbXLNK55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763217AbXLNK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:57:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761604AbXLNK5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:57:45 -0500
Date: Fri, 14 Dec 2007 11:56:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com, mbuesch@freenet.de,
       John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071214105624.GC23964@elte.hu>
References: <20071213003028.676998182@mvista.com> <200712131445.39770.mb@bu3sch.de> <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com> <200712140143.16451.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712140143.16451.mb@bu3sch.de>
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


* Michael Buesch <mb@bu3sch.de> wrote:

> > (eth0 is ethernet, eth1 doesn't exist -- usually it's the wireless.)
> > 
> > `ifconfig` doesn't see eth1 or wlan0_rename.
> > 
> > What else might I be doing wrong?
> 
> I don't know. Try ifconfig -a Or tell udev to not crap up your device 
> names.
> 
> > Regardless, perhaps scheduling bcm43xx for removal in 2.6.26 is a 
> > bit premature.
> 
> Oh come on. b43 is more than a year old now. How long should we wait? 
> Two or three? Forever?

possibly forever, if you dont get obvious regressions like "my wlan does 
not work" (reported in this very thread), resolved. Pushing the blame to 
udev (in a rather unfriendly way) wont give users a working system and 
wont get you many new testers for the new driver either.

	Ingo
