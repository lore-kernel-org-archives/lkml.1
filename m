Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZISSck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZISSck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZISSck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:32:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48093 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZISScj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:32:39 -0400
Date: Sat, 19 Sep 2009 20:32:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: reservetop fix disables mem=
Message-ID: <20090919183224.GA3038@elte.hu>
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org> <20090824182713.GB9785@elte.hu> <Pine.LNX.4.64.0909160117260.6814@sister.anvils> <20090919175504.GJ5366@elte.hu> <4AB51CA2.9010608@kernel.org> <4AB51DFD.2000904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB51DFD.2000904@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Yinghai Lu wrote:
> > Ingo Molnar wrote:
> >> I thoroughly zapped it. Do you know about any commit ID where it snuck 
> >> in?
> > 
> > after close looking, it will break
> > 1. some cpu feature  in early stage too, like cpu_has_x2apic
> > 2. will break built-in-command line
> > 3. will break other memmap= and mem=
> > 4. early_dbgp and early_console that will use early_ioremap to access mmio (?)

thanks Yinghai - i have queued up your revert. Thanks Hugh for noticing 
it!

> after revet it, it seem mem=32g etc still broken, maybe some other 
> commit about x86 platform support from Thomas broke it.

Thomas?

	Ingo
