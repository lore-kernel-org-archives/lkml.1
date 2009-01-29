Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZA2PEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZA2PEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZA2PEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:04:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbZA2PEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:04:08 -0500
Date: Thu, 29 Jan 2009 16:03:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Mehnert <Frank.Mehnert@Sun.COM>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v2] x86: add might_sleep() to do_page_fault()
Message-ID: <20090129150351.GD6512@elte.hu>
References: <200901290905.10966.frank.mehnert@sun.com> <200901291502.48312.frank.mehnert@sun.com> <1233238854.4495.93.camel@laptop> <200901291541.32618.frank.mehnert@sun.com> <1233241003.4495.97.camel@laptop> <20090129145921.GC6512@elte.hu> <1233241332.4495.99.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233241332.4495.99.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> 
> > should go into the 'else' branch i guess? In the down_read() case we 
> > already had the check.
> 
> True.
> 
> ---
> VirtualBox calls do_page_fault() from an atomic context but runs into a
> might_sleep() way pas this point, cure that.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/mm/fault.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Applied to tip/x86/mm, thanks Peter!

	Ingo
