Return-Path: <linux-kernel-owner+w=401wt.eu-S1765038AbYBMJCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765038AbYBMJCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYBMJCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:02:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39862 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbYBMJCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:02:31 -0500
Date: Wed, 13 Feb 2008 10:01:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>
Subject: Re: [ata crash] Re: Linux 2.6.25-rc1
Message-ID: <20080213090159.GA21614@elte.hu>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212081816.GA17820@elte.hu> <20080212071452.5c58ae6d@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212071452.5c58ae6d@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> btw this one was featured in the weekly bug top 10.. it's a rather 
> popular thing to happen.

i didnt get very far with bisection. .23 definitely did not crash and 
booted up fine - but it produced the "Bad IO ..." messages - so my 
automated bisector scripts which turned that warning into a crash&reboot 
honed in on the wrong (and probably uninteresting) area. .24 had 
timeouts but no crash. .25-rc1 had the crash. So it seems like multiple 
IDE regressions building up a concert of failures here, and it's hard to 
sort them out.

If an IDE/PATA/SATA person could take a look at the various logs i 
posted and could suggest the most efficient way to proceed it could save 
me from having to blindly spend hours on this problem.

	Ingo
