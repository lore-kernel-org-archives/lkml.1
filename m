Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYGIHnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYGIHnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYGIHnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:43:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbYGIHm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:42:59 -0400
Date: Wed, 9 Jul 2008 09:42:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Nick Piggin <npiggin@suse.de>,
       Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080709074237.GA7131@elte.hu>
References: <486A57C8.3010008@goop.org> <20080701203123.GG4896@elte.hu> <20080703091053.GA1883@elte.hu> <86802c440807031120o6e87459em8c4f239eb1a2507c@mail.gmail.com> <486D19B1.1080402@goop.org> <86802c440807031130keada2fbva256f2efe3c4801@mail.gmail.com> <486D1D40.9050309@goop.org> <86802c440807031151o577d001g3e72bae3aa88df25@mail.gmail.com> <86802c440807031219w1355c31axb4daf78f3ec626ed@mail.gmail.com> <86802c440807031229m4f39139ar961346bc30e4a41e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807031229m4f39139ar961346bc30e4a41e@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >> it could be address continuous checkup for printout in 
> >> vmemmap_populated has some problem...
> >
> > you moved p_end = p + PMD_SIZE before...
> >
> > if (p_end != p || node_start != node) {
> 
> Ingo,
> 
> please put attached patch after jeremy's xen pv64 patches.
> 
> YH

> [PATCH] x86: fix vmemmap printout check

applied, thanks.

	Ingo
