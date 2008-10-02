Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYJBWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYJBWdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYJBWdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:33:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:50168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbYJBWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:33:17 -0400
Date: Thu, 2 Oct 2008 15:33:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
 interrupt handlers
Message-ID: <20081002153305.057cf6d9@infradead.org>
In-Reply-To: <20081002213146.GA9201@kroah.com>
References: <20081001223213.078984344@linutronix.de>
	<873ajfoy1a.fsf@basil.nowhere.org>
	<20081002213146.GA9201@kroah.com>
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

On Thu, 2 Oct 2008 14:31:46 -0700
Greg KH <greg@kroah.com> wrote:

> On Thu, Oct 02, 2008 at 04:46:09PM +0200, Andi Kleen wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> > >
> > >  - move long running handlers out of the hard interrupt context
> > 
> > I'm not sure I'm really looking forward to this brave new world
> > of very long running interrupt handlers. e.g. what do you
> > do for example when some handler blocks for a very long time?
> 
> We have this issue today with some irqs (USB is known for issue
> here...)
> 
> So I don't think this is a big issue, and in the end, a better idea as
> it might force us to confront some of the big abusers and fix them.
> 

one of the things irq threads gives you is that 'top' will show you
which ones are eating cpu ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
