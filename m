Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYGOIPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYGOIPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYGOIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:15:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbYGOIP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:15:27 -0400
Date: Tue, 15 Jul 2008 10:14:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715081431.GB16600@elte.hu>
References: <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <487C1648.5070409@garzik.org> <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org> <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216107418.27455.236.camel@shinybook.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2008-07-15 at 03:21 -0400, Jeff Garzik wrote:
> > * forced a flag day build process change upon all distros/builders 
> > who switch to >= 2.6.27.  no build script updates == non-working 
> > drivers.
> 
> Jeff, we don't usually call it a 'flag day' when it's just the normal 
> and uninteresting case that you update the upstream version of the 
> package, and you need minor tweaks to how you package it. [...]

well, i have no opinion one way or another about the firmware issue, but 
breaking the build and breaking previously working setups is not a 
"minor tweak".

> [...] That happens all the time. [...]

No, you are quite wrong, it does not happen all the time.

It happens occasionally out of 10,000 changes per kernel cycle. It 
happens unintentionally most of the time and it's called a regression.

The difference here is that you seem to have broken my setup fully 
intentionally.

I have no problem with going forward, but i have a problem with breaking 
working setups and i have a problem with forced migration to something 
that doesnt work by default.

If there's a fix i can apply and test i'm a happy camper, but all this 
arguing in these threads with zero patches posted makes me quite 
nervous.

	Ingo
