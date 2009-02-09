Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZBIJpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZBIJpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZBIJpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:45:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZBIJpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:45:43 -0500
Date: Mon, 9 Feb 2009 10:44:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       ralf@linux-mips.org, mingo@redhat.com
Subject: Re: x86: spinlocks: define dummy __raw_spin_is_contended
Message-ID: <20090209094440.GA13942@elte.hu>
References: <20090208180341.GC11398@bombadil.infradead.org> <20090208223958.GA19888@bombadil.infradead.org> <20090209092221.GG31890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209092221.GG31890@elte.hu>
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

> 
> * Kyle McMartin <kyle@infradead.org> wrote:
> 
> > CC-ing Linus, since he just released 2.6.29-rc4, which will fail to
> > build btrfs on anything besides mips or x86.
> 
> Hm, i'm not particularly fond of the spin_is_contended() trickery done in:

having said that, Kyle's patch is obviously correct nevertheless - the above
is not to be taken as an objection.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
