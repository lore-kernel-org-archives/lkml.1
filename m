Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYJCDtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYJCDtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYJCDtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:49:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:38024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbYJCDtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:49:16 -0400
Date: Thu, 2 Oct 2008 20:48:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
 interrupt handlers
Message-ID: <20081002204851.1836e465@infradead.org>
In-Reply-To: <20081003032504.GF8318@one.firstfloor.org>
References: <20081001223213.078984344@linutronix.de>
	<873ajfoy1a.fsf@basil.nowhere.org>
	<20081002213146.GA9201@kroah.com>
	<20081002153305.057cf6d9@infradead.org>
	<20081003032504.GF8318@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 05:25:04 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > 
> > one of the things irq threads gives you is that 'top' will show you
> > which ones are eating cpu ;-)
> 
> oprofile does that job fine already and is imho any time preferable
> for detailed analysis.

while I don't disagree that oprofile will give you more detailed
results, I think there's a HUGE difference between asking a bugreporter
"can you paste a screen of 'top'" and "can you configure and run
oprofile".
CHances are good that the user already thought of top him/herself and
just reports "interrupt X is eating CPU" rather than "something seems
to be eating CPU".

I'm not going argue that this alone is enough justification for
irqthreads, but you can't deny it's an advantage.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
