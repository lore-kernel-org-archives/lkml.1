Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYHOTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYHOTBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYHOTBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:01:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49832 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030AbYHOTBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:01:01 -0400
Date: Fri, 15 Aug 2008 21:00:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>, Arjan van de Ven <arjan@infradead.org>,
       akpm@linux-foundation.org, hugh@veritas.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, briangrant@google.com, cgd@google.com,
       mbligh@google.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
	64b context switch optimization?
Message-ID: <20080815190034.GA15356@elte.hu>
References: <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com> <20080813154043.GA11886@elte.hu> <48A303EE.8070002@redhat.com> <20080813160218.GB18037@elte.hu> <20080815155457.GA5210@shareable.org> <48A5B943.1010607@gmail.com> <20080815171913.GB23600@elte.hu> <a36005b50808151023s7baffae5w8e163046209ce9dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50808151023s7baffae5w8e163046209ce9dc@mail.gmail.com>
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


* Ulrich Drepper <drepper@gmail.com> wrote:

> On Fri, Aug 15, 2008 at 10:19 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > ( also, just to make sure: all Linux kernel versions will ignore such
> >  extra flags, so you can just update glibc to use this flag
> >  unconditionally, correct? )
> 
> As soon as the patch hits Linus' tree I can change the code.

it's upstream now:

| commit cd98a04a59e2f94fa64d5bf1e26498d27427d5e7
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Wed Aug 13 18:02:18 2008 +0200
|
|     x86: add MAP_STACK mmap flag

thanks everyone,

	Ingo
