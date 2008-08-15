Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYHON3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYHON3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbYHON3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:29:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759132AbYHON3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:29:09 -0400
Date: Fri, 15 Aug 2008 15:28:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix /proc/meminfo DirectMap
Message-ID: <20080815132854.GG30597@elte.hu>
References: <Pine.LNX.4.64.0808151351220.28840@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808151351220.28840@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> Do we actually want these DirectMap lines in the x86 /proc/meminfo? I 
> can see they're interesting to CPA developers and TLB optimizers, but 
> they don't fit its usual "where has all my memory gone?" usage. If 
> they are to stay, here are some fixes.

i think they are borderline useful - so i've applied your fixes to 
tip/x86/urgent.

> You might prefer me to split these up?

nah.

> Should we really be using level2_ident_pgt (which needs to avoid NX) 
> for the final direct map (which wants to use NX)?  But my attempt to 
> build up a fresh pagetable there failed miserably to boot!

hm, exactly what change have you tried? (patch?)

	Ingo
