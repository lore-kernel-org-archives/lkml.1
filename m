Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbYADLD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbYADLD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYADLDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:03:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYADLDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:03:48 -0500
Date: Fri, 4 Jan 2008 12:03:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use __u64 in aligned_u64's definition
Message-ID: <20080104110333.GA26149@elte.hu>
References: <Pine.LNX.4.64.0801022135500.14900@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.00.0801021251040.32517@woody.linux-foundation.org> <Pine.LNX.4.64.0801022225460.14900@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.00.0801021341070.3010@woody.linux-foundation.org> <Pine.LNX.4.64.0801022243450.14900@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801022243450.14900@fbirervta.pbzchgretzou.qr>
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


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Jan 2 2008 13:42, Linus Torvalds wrote:
> >On Wed, 2 Jan 2008, Jan Engelhardt wrote:
> >>
> >> A cleanup. Or perhaps a precautionary change, should unsigned long
> >> long ever become something that is not 64-bit. It was intended for
> >> 2.6.25 actually. You don't take patches this early, do you?
> >
> >Yeah, no, I don't take patches early. I've considered setting up another 
> >branch for early patches, but decided that I'm (a) lazy and (b) better off 
> >encouraging people in the late -rc timeframe to just concentrate on the 
> >-rc's, not the next version.
>
> Well you can also apply it right now, then it's done and life can go 
> on.

which part of the "it's an unnecessary distraction" concept didnt you 
understand? We are in -rc6 and all the codebase is in deep freeze. Delay 
your patch to when the 2.6.25 merge window starts and life can go on.

	Ingo
