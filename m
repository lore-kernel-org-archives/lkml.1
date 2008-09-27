Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYI0Suq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYI0Suq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYI0Sui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:50:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60530 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYI0Sui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:50:38 -0400
Date: Sat, 27 Sep 2008 20:50:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080927185027.GB17867@elte.hu>
References: <20080924183517.GA24209@nostromo.devel.redhat.com> <20080925091558.GE16734@elte.hu> <20080925161300.GA17162@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925161300.GA17162@nostromo.devel.redhat.com>
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


* Bill Nottingham <notting@redhat.com> wrote:

> Ingo Molnar (mingo@elte.hu) said: 
> > > (Alternatively, just remove them, of course...)
> > 
> > LOL :) Applied the commit below to tip/x86/debug, thanks Bill!
> 
> Does the 'kernel alive' right before it serve any purpose either?

that has some marginal use: it shows that we are past the really basic 
system setup code, we decompressed the kernel and entered protected mode 
with boot paging enabled.

we had bugs in the past where we'd hang/crash after GRUB starts us and 
before we reach this printk.

OTOH ... forcing it upon all users is strong. Feel free to send another 
patch that removes it.

	Ingo
