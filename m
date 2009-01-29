Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZA2LOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZA2LOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 06:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZA2LOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 06:14:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZA2LOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 06:14:10 -0500
Date: Thu, 29 Jan 2009 12:13:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, npiggin@suse.de, torvalds@linux-foundation.org,
       tglx@linutronix.de, arjan@infradead.org
Subject: Re: [PATCH] use per cpu data for single cpu ipi calls
Message-ID: <20090129111330.GB30738@elte.hu>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <200901290955.38940.rusty@rustcorp.com.au> <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com> <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233218954.7835.11.camel@twins>
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

> > Can generic_smp_call_function_single_interrupt() ever see 
> > CSD_FLAG_ALLOC set now?  If not, that kfree can go away.
> 
> Like said above, removing that kmalloc will hurt people.

the whole promise of generic-IPI seems to dwindle and we'll get back to 
roughly where we started out from.

	Ingo
