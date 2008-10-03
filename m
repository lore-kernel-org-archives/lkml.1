Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYJCDTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYJCDTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYJCDTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:19:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYJCDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:19:21 -0400
Date: Fri, 3 Oct 2008 05:25:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt handlers
Message-ID: <20081003032504.GF8318@one.firstfloor.org>
References: <20081001223213.078984344@linutronix.de> <873ajfoy1a.fsf@basil.nowhere.org> <20081002213146.GA9201@kroah.com> <20081002153305.057cf6d9@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002153305.057cf6d9@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 03:33:05PM -0700, Arjan van de Ven wrote:
> On Thu, 2 Oct 2008 14:31:46 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Oct 02, 2008 at 04:46:09PM +0200, Andi Kleen wrote:
> > > Thomas Gleixner <tglx@linutronix.de> writes:
> > > >
> > > >  - move long running handlers out of the hard interrupt context
> > > 
> > > I'm not sure I'm really looking forward to this brave new world
> > > of very long running interrupt handlers. e.g. what do you
> > > do for example when some handler blocks for a very long time?
> > 
> > We have this issue today with some irqs (USB is known for issue
> > here...)
> > 
> > So I don't think this is a big issue, and in the end, a better idea as
> > it might force us to confront some of the big abusers and fix them.
> > 
> 
> one of the things irq threads gives you is that 'top' will show you
> which ones are eating cpu ;-)

oprofile does that job fine already and is imho any time preferable
for detailed analysis.

-andi

-- 
ak@linux.intel.com
