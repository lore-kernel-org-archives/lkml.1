Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYAAREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYAAREU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYAAREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:04:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYAAREG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:04:06 -0500
Date: Tue, 1 Jan 2008 17:57:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 1/2] remove __init modifier from header declaration
Message-ID: <20080101165732.GB3488@elte.hu>
References: <11979967763153-git-send-email-gcosta@redhat.com> <20071219101236.GB3521@elte.hu> <20071231164624.GA1738@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231164624.GA1738@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > thanks, applied.
> > 
> > btw., people have been talking about reducing the include file mess 
> > for nearly a decade now,
> 
> Some of us are actually doing it. ;-)

sorry, this was really not meant to slight your contributions in this 
area in any way :-) I'm just judging by the spaghetti still hanging 
around in asm-x86/*.h, and the 'fun' we have with paravirt and its type 
dependencies - and the periodic messups we have with macros. (and many 
macros are not inlines due to ugly dependencies.)

> > So include file dependency flattening patches would be more than 
> > welcome as well.
> 
> Yup! Provided they're compile-tested sufficiently well.

as long as it builds/boots on your box with a single convenient .config 
of yours, we can stick such patches into x86.git and work out all the 
build failures it might cause.

> > (and unlike unification patches they have no expectation of being 
> > 100% perfect, so a natural ping-pong of fixes, until the changes are 
> > fully correct, would be natural.)
> 
> That way you'll never clean anything especially during merge window. 
> ;-)

hm, what do you mean?

	Ingo
