Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbZABPld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbZABPld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZABPlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:41:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZABPlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:41:24 -0500
Date: Fri, 2 Jan 2009 16:41:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PDA changes (take 2, resend)
Message-ID: <20090102154112.GC1180@elte.hu>
References: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
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


* Brian Gerst <brgerst@gmail.com> wrote:

> Here are the PDA patches again.  I changed the first patch so that the 
> PDA is cacheline aligned.  I dropped the cpunumber patch for now, and 
> added conversions of the TLB state and IRQ stats to match the 32-bit 
> code.  Stats for defconfig:
> 
>   text    data     bss     dec     hex filename
> 7033649 1754476  758508 9546633  91ab89 vmlinux.before
> 7029643 1754716  758508 9542867  919cd3 vmlinux.after
> 
> Patches are against 2.6.28.

looks pretty good!

	Ingo
