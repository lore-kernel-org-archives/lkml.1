Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZCEKjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZCEKjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZCEKjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:39:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZCEKjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:39:42 -0500
Date: Thu, 5 Mar 2009 11:38:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] x86: make text_poke() atomic using fixmap
Message-ID: <20090305103852.GD32407@elte.hu>
References: <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <49AC7453.8020307@redhat.com> <20090303002214.GA4147@elte.hu> <49AC7A5F.7080009@redhat.com> <49AD5B55.10002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD5B55.10002@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Ingo,
> 
> Here is the patch which uses fixmaps instead of vmap in 
> text_poke(). This made the code much simpler than I thought 
> :).

Looks good to me at a quick glance albeit Linus had second 
thoughts about using fixmaps for this in the past. But with 
delayed-flush for vmaps i think fixmaps are again the simpler 
and more robust - albeit more limited - choice ...

In any case, the x86 tree already unified fixmap.h so could you 
please resend the whole series as a 0/3, 1/3, 2/3, 3/3 thing 
against tip:master, starting a new thread on lkml? (this thread 
is already way too deep)

	Ingo
