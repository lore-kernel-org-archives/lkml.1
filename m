Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbYGCM4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbYGCM4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYGCMz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:55:59 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:60958 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYGCMz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:55:58 -0400
Date: Thu, 3 Jul 2008 11:10:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080703091053.GA1883@elte.hu>
References: <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48696690.90907@goop.org> <20080701085204.GA23289@elte.hu> <20080701092152.GA18918@elte.hu> <486A57C8.3010008@goop.org> <20080701203123.GG4896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701203123.GG4896@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Ingo Molnar wrote:
> >> Excluding the x86/xen-64bit topic solves the problem.
> >>
> >> It triggered on two 64-bit machines so it seems readily reproducible  
> >> with that config.
> >>
> >> i've pushed the failing tree out to tip/tmp.xen-64bit.Tue_Jul__1_10_55
> >>   
> >
> > The patch to fix this is on tip/x86/unify-setup: "x86: setup_arch() && 
> > early_ioremap_init()".  Logically that patch should probably be in the 
> > xen64 branch, since it's only meaningful with the early_ioremap 
> > unification.
> 
> ah, indeed - it was missing from tip/master due to:
> 
> | commit ac998c259605741efcfbd215533b379970ba1d9f
> | Author: Ingo Molnar <mingo@elte.hu>
> | Date:   Mon Jun 30 12:01:31 2008 +0200
> |
> |    Revert "x86: setup_arch() && early_ioremap_init()"
> |
> |    This reverts commit 181b3601a1a7d2ac3ace6b23cb3204450a4f9a27.
> 
> because that change needed the other changes from xen-64bit.
> 
> will retry tomorrow.

ok, i've re-added x86/xen-64bit and it's looking good in testing so far.

	Ingo
