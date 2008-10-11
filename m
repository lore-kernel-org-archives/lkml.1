Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYJKI3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYJKI3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 04:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYJKI26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 04:28:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYJKI2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 04:28:55 -0400
Date: Sat, 11 Oct 2008 10:28:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] fastboot tree for v2.6.28
Message-ID: <20081011082845.GA28715@elte.hu>
References: <20081010003241.GA23940@elte.hu> <alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org> <20081010154929.6ec201fe@infradead.org> <20081011064712.GA25451@elte.hu> <20081011004840.5ad62ce0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011004840.5ad62ce0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 11 Oct 2008 08:47:12 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > When i saw your patches then initially my impression was "oh my, 
> > this will break a ton of stuff", so i asked you to: make it 
> > default-off (against Andrew's suggestion to just remove the config 
> > and make it a compulsory feature)
> 
> hm, that must have been the other Andrew.

on 14th August you wrote:

|| Making it a config options seems a bad idea - it'll split our 
|| testing/debugging space yet again.  If this stuff works, then 
|| everyone should be able to use it.  If it doesn't work, well....

this i understood as: "if we take this stuff then it should be 
always-on". [You didnt say whether we should take it though.]

> A feature like this I think should not have a config option but should 
> be enabled by a boot option.
>
> We can waffle about the default setting of that option.  Maybe turn it 
> on for a few weeks and see what happens.

a config option is definitely useful for users and distros. Having the 
boot option is a good idea. Arjan, i thought we had a fastboot=0/1 boot 
option but i cannot find it - could you please add it?

	Ingo
