Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYABQHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYABQHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYABQHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:07:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbYABQHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:07:34 -0500
Date: Wed, 2 Jan 2008 17:07:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier@gentoo.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] asm-x86/msr.h: pull in linux/types.h
Message-ID: <20080102160706.GB21046@elte.hu>
References: <200801012008.53275.vapier@gentoo.org> <20080102114849.GA25887@elte.hu> <200801020837.53860.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801020837.53860.vapier@gentoo.org>
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


* Mike Frysinger <vapier@gentoo.org> wrote:

> On Wednesday 02 January 2008, Ingo Molnar wrote:
> > * Mike Frysinger <vapier@gentoo.org> wrote:
> > > Forgot to mention this before, but since the msr.h header uses types
> > > like __u32, it should pull in linux/types.h.
> >
> > does not build with the attached config.
> 
> sorry, forgot about __ASSEMBLY__ protection.

thanks, applied.

(note, your patch was not plaintext, had to fix it by hand)

	Ingo
