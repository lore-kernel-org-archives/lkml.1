Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbZDHO4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbZDHO4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZDHOzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:55:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZDHOzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:55:50 -0400
Date: Wed, 8 Apr 2009 16:54:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
Message-ID: <20090408145440.GN12931@elte.hu>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

>  include/asm-frv/pgtable.h          |    4 +-

Needs the ack of the FRV arch maintainer both for content and for 
flow (i.e. via x86 tree). If any second thoughts are expressed about 
the flow then this needs to go on separate tracks.

>  include/asm-generic/pgtable.h      |   21 +++++++------

Needs the ack of arch maintainers in general and a linux-arch 
cross-post.

>  kernel/sched.c                     |    2 -

Needs the ack of ... oh, never mind - this one is fine i guess ;-)

	Ingo
