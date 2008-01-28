Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYA1Mz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYA1Mz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760730AbYA1Mzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:55:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34279 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYA1Mzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:55:48 -0500
Date: Mon, 28 Jan 2008 13:55:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24 regression: Wake On Lan in sky2 broken on Mac mini
Message-ID: <20080128125535.GE32496@elte.hu>
References: <20080128002934.GA6354@dose.home.local> <18333.37002.749771.524523@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18333.37002.749771.524523@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

>  > Now I tried the 2.6.24 release and noticed that WOL is still 
>  > broken. I'll be happy to test any patches that can make it into 
>  > 2.6.24.1.
> 
> 1. Wrong mailing list; use netdev (@vger) instead.

lkml is the right mailing list for reporting Linux bugs.

this is an extermely harmful trend i've seen lately: some kernel hackers 
going out on a limb directing the flow of bugreports _away_ from lkml, 
by suggesting to testers that lkml is somehow inappropriate for 
reporting Linux kernel bugs.

It's not even the standard "I Cc:-ed netdev, maybe they are interested 
in this" message but the above, plain incorrect: "this is the wrong 
mailing list" message.

Mikael, what you do is as harmful to Linux as if you were intentionally 
putting bugs into the kernel source. In fact it's more harmful because 
it is irreversible: bugs you put into Linux i can fix and i can review 
all past patches you did to undo the damage - tester attention and 
feedback you redirect we cannot direct back. Stop it!

	Ingo
