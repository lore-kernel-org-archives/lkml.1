Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZL1Isl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZL1Isl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZL1Isk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:48:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZL1Isk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:48:40 -0500
Date: Mon, 28 Dec 2009 09:48:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v3)
Message-ID: <20091228084821.GA24690@elte.hu>
References: <4B2BB5830200007800026AC7@vpn.id2.novell.com>
 <alpine.LFD.2.00.0912180822380.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912180822380.3712@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 18 Dec 2009, Jan Beulich wrote:
> >
> > -static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> > +static __always_inline u8 __ticket_spin_trylock(arch_spinlock_t *lock)
>
[...]
>
> I dunno. I still don't get the feeling that any of this actually 
> _matters_.

Jan, to apply this patch it would be nice to see a before/after 
comparison/analysis of a defconfig vmlinux image with a reasonably uptodate 
GCC - to see how much this all matters in practice.

	Ingo
