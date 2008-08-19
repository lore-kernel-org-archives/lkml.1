Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYHSBUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYHSBUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYHSBT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:19:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbYHSBT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:19:57 -0400
Date: Tue, 19 Aug 2008 03:19:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alex Nixon <alex.nixon@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector
	0x6 cpu 1'
Message-ID: <20080819011937.GD14821@elte.hu>
References: <48A976E6.40906@citrix.com> <48A9EBBD.5010509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9EBBD.5010509@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Alex Nixon wrote:
> > From: Alex Nixon <alex.nixon@citrix.com>
> > Date: Mon, 18 Aug 2008 12:56:48 +0100
> > Subject: [PATCH] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
> >
> > Following commit 9c3f2468d8339866d9ef6a25aae31a8909c6be0d, do_IRQ() looks up the IRQ number in the per-cpu variable vector_irq.
> >
> > This commit makes Xen initialise an identity vector_irq map for both X86_32 and X86_64.
> >   
> 
> Thanks Alex.
> 
> Ingo, please apply.
> 
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

i didnt get the original patches (they arent on lkml) - could you please 
resend them with your Acked-by line added as well?

by the looks of it, both are needed for v2.6.27, agreed?

	Ingo
