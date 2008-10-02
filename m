Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYJBKwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYJBKwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 06:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYJBKwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 06:52:05 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:45449 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYJBKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 06:52:04 -0400
Subject: Re: [RFC patch 2/5] genirq: add a quick check handler
From: Jon Masters <jonathan@jonmasters.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <alpine.DEB.1.10.0810020107210.11373@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>
	 <20081001223301.900862899@linutronix.de>
	 <1222908459.31183.73.camel@perihelion.int.jonmasters.org>
	 <alpine.DEB.1.10.0810020107210.11373@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 02 Oct 2008 06:51:49 -0400
Message-Id: <1222944709.26632.19.camel@perihelion.int.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 01:09 -0400, Steven Rostedt wrote:
> On Wed, 1 Oct 2008, Jon Masters wrote:
> > 
> > We probably need some documentation eventually so people realize what
> > this "quickcheck" handler is for and what it's not for - under no
> > circumstances should anything more than the bare minimum be done.
> > Otherwise it breaks the benefit of deferred threaded handling. It's hard
> > to enforce that - but this is *not* a return of top/bottom half handling
> > where you can do whatever crap you like in the quickcheck bit.
> > 
> 
> We could always implement something similar to what I was told Microsoft 
> does (I was just told this, I don't know for fact). Time this function and 
> if it takes longer than, say 50us, print a warning and kill the device
> ;-)

You know, it's funny you suggested that because I thought about going
there. But there's probably some silly patent on that groundshattering
Microsoft solution to the halting problem.

Anyway, I like to think we in the Linux community trust developers to do
the right thing more than Microsoft does :)

Jon.


