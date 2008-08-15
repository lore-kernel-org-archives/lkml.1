Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYHOPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYHOPm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYHOPmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:42:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40825 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbYHOPmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:42:49 -0400
Date: Fri, 15 Aug 2008 17:42:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: update recordmount.pl arch changes
Message-ID: <20080815154234.GE27955@elte.hu>
References: <alpine.DEB.1.10.0808151136310.2188@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808151136310.2188@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I'm trying to keep all the arch changes in recordmcount.pl in one 
> place. I moved your code into that area, by adding the flags to the 
> commands that were passed in.
> 
> Does this change still work for you when compiling i386 on a x86_64 
> box?

actually, i thought of this as a quick hack to let -tip testing 
continue. Dont we have all the proper information available in kbuild 
and should just pass that to scripts/recordmcount.pl when called - like 
we pass in things like OBJDUMP which might have cross-build overrides, 
etc.

	Ingo
