Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbZHUI2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbZHUI2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176AbZHUI2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:28:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbZHUI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:28:14 -0400
Date: Fri, 21 Aug 2009 10:27:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] Fix Xen boot with CONFIG_CC_STACKPROTECTOR
Message-ID: <20090821082740.GC23993@elte.hu>
References: <4A8C98DD.2020709@goop.org> <20090820100644.GC29093@elte.hu> <4A8D78C1.5070708@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8D78C1.5070708@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 08/20/09 03:06, Ingo Molnar wrote:
> >> I only need to disable stackprotector for a
> >> handful of functions, but unfortunately it looks like it can only be
> >> disabled on a per-file basis.
> > Pulled into tip:x86/urgent, thanks a lot Jeremy!
> >
> > Btw., is there any way to turn off stackprotector on a 
> > per function basis, a GCC attribute perhaps? That would 
> > be preferable to turning it off for all of common.o.
> 
> Yeah, its awkward.  But it looks like this patch is not 
> sufficient, so drop it for now.  I'll send a replacement shortly 
> (though it doesn't hurt to keep it; I can just generate a delta if 
> that's better).

I already pulled it as the fixes looked right so please send a delta 
based on top of tip:x86/urgent.

Thanks,

	Ingo
