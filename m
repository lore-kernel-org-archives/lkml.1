Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZGEL0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZGEL0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZGEL0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:26:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZGEL0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:26:15 -0400
Date: Sun, 5 Jul 2009 13:25:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: Move the 32-bit
	atomic64_t implementation to a .c file
Message-ID: <20090705112545.GA1062@elte.hu>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-b7882b7c65abb00194bdb3d4a22d27d70fcc59ba@git.kernel.org> <19022.40132.606734.933933@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19022.40132.606734.933933@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> tip-bot for Ingo Molnar writes:
> 
> > Also, while at it, rename all uses of 'unsigned long long' to
> > the much shorter u64.
> > 
> > This makes the appearance of the prototypes a lot nicer - and
> > it also uncovered a few bugs where (yet unused) API variants
> > had 'long' as their return type instead of u64.
> 
> Did you consider making atomic64_t a signed type on 32-bit x86 
> like it is on all 64-bit platforms, and like atomic_t is 
> everywhere?

That did not occur to me and it makes sense - this would clean up a 
few explicit s64 casts we do there currently.

	Ingo
