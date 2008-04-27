Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbYD0XHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbYD0XHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYD0XHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:07:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYD0XHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:07:33 -0400
Date: Sun, 27 Apr 2008 16:07:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Breakage caused by unreviewed patch in x86 tree
Message-ID: <20080427160711.2b61f592@laptopd505.fenrus.org>
In-Reply-To: <20080427.160041.223283677.davem@davemloft.net>
References: <1209329485.3801.46.camel@localhost.localdomain>
	<20080427155803.73f0efcf@laptopd505.fenrus.org>
	<20080427.160041.223283677.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 16:00:41 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Arjan van de Ven <arjan@infradead.org>
> Date: Sun, 27 Apr 2008 15:58:03 -0700
> 
> > On Sun, 27 Apr 2008 16:51:25 -0400
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > This patch:
> > > 
> > > commit 6371b495991debfd1417b17c2bc4f7d7bae05739
> > > Author: Ingo Molnar <mingo@elte.hu>
> > > Date:   Wed Jan 30 13:33:40 2008 +0100
> > > 
> > >     x86: change ioremap() to default to uncached
> > > 
> > > As far as I can tell went blindly into the x86 tree without being
> > > shared on any mailing list at all.  How can something that
> > > completely alters the semantics of ioremap on x86 platforms go in
> > > without any review.
> > 
> > it changed from "whatever coinflip you got" to "predictable
> > outcome". 
> 
> You're making technical responses to a question about process.

ok on a process side it is basically a "go from 99.9% to 100%" bugfix ;(

Anyone who claims that ioremap() on x86 was cached before doesn't understand the issue,
it was NOT cached. It was "almost always uncached". The bugfix here is to take away the
"almost" part.
Should that have been posted to lkml more vocally? Wouldn't have hurt. No argument about that.
Is it as big a deal as this thread makes it sound? Absolutely not! The change in behavior
or even semantics is almost zero.  


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
