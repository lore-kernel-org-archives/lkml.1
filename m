Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZGCGOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZGCGOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZGCGOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:14:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZGCGOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:14:22 -0400
Date: Fri, 3 Jul 2009 08:14:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Howells <dhowells@redhat.com>,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: atomic64_t should be 8 bytes aligned
Message-ID: <20090703061414.GA23990@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain> <4A4D2FDA.3000509@gmail.com> <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 3 Jul 2009, Eric Dumazet wrote:
> > 
> > So we probably need an __attribute__((aligned(8)) on atomic64_t 
> > definition as well, since alignof(atomic64_t) is 4, not 8 (!!!)
> 
> Ack. Ingo, Peter, I'm hoping you're collecting these things?

Yeah, of course.

	Ingo
