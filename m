Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbXLNSAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbXLNSAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXLNSAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:00:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbXLNSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:00:05 -0500
Date: Fri, 14 Dec 2007 18:59:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, stefano.brivio@polimi.it,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Daniel Walker <dwalker@mvista.com>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, mbuesch@freenet.de, linux@bohmer.net,
       kjwinchester@gmail.com, jonathan@jonmasters.org,
       akpm@linux-foundation.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071214175910.GA27078@elte.hu>
References: <20071213003028.676998182@mvista.com> <2c0942db0712140827x38e5d971sbdb3d5864fc32364@mail.gmail.com> <2c0942db0712140845p1dfd8b23va13525b75224f4c0@mail.gmail.com> <200712141759.59273.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712141759.59273.mb@bu3sch.de>
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

> In my opinion this all is the work of the distributions and not the 
> work of the kernel developers. Distributions have to make sure that 
> everything works after a kernel update. [...]

actually, not. The the task of kernel developers is to KEEP OLD 
DISTRIBUTIONS WORKING WITH NEW DRIVERS. Or the "old" driver stays around 
until eternity, because the new one is just BROKEN.

Take a look at CONFIG_COMPAT_VDSO for example - one single version of 
glibc was released in a distro that depended on a kernel vDSO bug. So 
we'll keep that aspect of the vDSO perhaps forever. Simple as that. 
Stuff must just work. Whatever it takes. Best is if you add in new stuff 
without the user noticing _ANYTHING_ but that the kernel version bumped. 
If the maintainers of the other 7 million lines of kernel code can get 
this right then the wireless code should be able to do it too. Ok?

all this "distributors will have to sort out the mess" talk is nonsense, 
and i really hope you do not truly believe in that crap. If your 
attitude is prevalent in the wireless development community then it's in 
worse shape than i thought :-(

	Ingo
