Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYJEJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYJEJfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYJEJfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:35:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbYJEJfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:35:32 -0400
Date: Sun, 5 Oct 2008 11:35:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] dumpstack: x86: various small unification steps
Message-ID: <20081005093523.GE16819@elte.hu>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Hi Ingo,
> 
> Here is the first round of unification of dumpstack_32.c
> and dumpstack_64.c. The first patch can also be seen as
> a clean-up of the traps.c-unification as I forgot to move
> one function at the time. Anyhow, the series depends on
> the traps unification.

great - i've created tip/x86/dumpstack for this and applied your patches 
there. (that branch embedds tip/x86/core which already embedds 
tip/x86/traps)

> B.T.W., I could reproduce the spontaneous reboot with the
> traps unification with glibc. The change GATE_INTERRUPT -> 
> GATE_TRAP fixed the crash there. Usually I test only with
> a small klibc-based userspace, and there the reboot does
> not happen. I guess the int 0x80 interface is less picky.
> (Just to say that I do test the changes a bit ;) )

it also passed -tip testing still then so the changes are fine. 

Generally if you see your commits show up and stay in tip/master it 
means they get tested with a newly built random kernel about once every 
two minutes or so.

regarding klibc, that's interesting: is that the in-kernel klibc from 
hpa? Which tree are you using to pull that into tip/master? (unless i 
misunderstood what you are doing)

	Ingo
