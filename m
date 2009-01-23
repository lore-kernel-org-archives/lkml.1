Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbZAWRqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbZAWRqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZAWRq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:46:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZAWRq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:46:27 -0500
Date: Fri, 23 Jan 2009 18:45:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       L-K <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] x86,mm: fix pte_free()
Message-ID: <20090123174543.GA16348@elte.hu>
References: <1232728669.4826.143.camel@laptop> <20090123173421.GA30980@elte.hu> <1232732387.4850.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232732387.4850.1.camel@laptop>
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

> On Fri, 2009-01-23 at 18:34 +0100, Ingo Molnar wrote:
> 
> > So i agree with the fix, but the patch does not look right: shouldnt that 
> > be pgtable_page_dtor(pte), so that we get ->mapping cleared via 
> > pte_lock_deinit()? (which i guess your intention was here - this probably 
> > wont even build)
> 
> Yeah, I somehow fudged it, already send out a better one. -- One of them
> days I guess :-(

no problem - applied to tip/x86/urgent, thanks Peter!

	Ingo
