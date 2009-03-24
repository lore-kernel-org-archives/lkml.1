Return-Path: <linux-kernel-owner+w=401wt.eu-S1763041AbZCXTns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041AbZCXTns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761762AbZCXTnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:43:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762268AbZCXTnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:43:14 -0400
Date: Tue, 24 Mar 2009 20:42:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: sinter <sinter.salt@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
Subject: Re: BUG in 2.6.29 final: broken network connection
Message-ID: <20090324194254.GB26930@elte.hu>
References: <200903241812.14577.sinter.salt@gmx.de> <20090324172503.1627a3ef@lxorguk.ukuu.org.uk> <200903241918.29929.sinter.salt@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903241918.29929.sinter.salt@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* sinter <sinter.salt@gmx.de> wrote:

> Am Dienstag 24 März 2009 18:25:03 schrieben Sie:
> > > It cost me almost 1 complete day
> >
> > Wouldn't it have been simpler to wait when you found a problem and read
> > Ingo's email on the subject from a few hours ago ?
> 
> Wouldn't it be simpler to restrictively avoid crap code in final 
> kernel versions? And if that does not work by appeal shouldn't the 
> netdev maintainer simply be substituted?
> 
> Who needs a maintainer adding his SOB with closed eyes under 
> untested crap code? Who needs someone like that for kernel 
> development?

Nonsense. 303c6a0 "gro: Fix legacy path napi_complete crash" was an 
obvious looking bug fix for a real crash that was reported, against 
a commit that went upstream in 2.6.29-rc1.

It was a fix for a serious regression and i'd have applied it too, 
and would have pushed it to Linus.

Furthermore, even on affected systems it took certain configs and 
certain conditions for the bug to trigger under high load. So there 
was no real good way to find this bug quickly.

Such kind of bugs can happen anytime, to any maintainer. Unless we 
100% freeze the kernel for a full month before release, this risk 
simply cannot be avoided. It is far more problematic if maintainers 
dont push known fixes or ignore fixes. The networking tree is 
exemplary in picking up fixes addressing bug reports quickly. A 
proposed fix was posted 33 minutes after i sent my bugreport.

Things breaking is simply the nature of software changes - get used 
to it. When new software with 1 million lines of changes over the 
previous version comes out, dont jump on it immediately, if your 
peace of mind depends on a 100% working system. Only try it if you 
want to help out developing it.

And there's an easy solution for you in any case: you can wait for 
.29.1 which i'm sure will be out quickly.

Thanks,

	Ingo
