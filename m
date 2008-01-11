Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbYAKJvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbYAKJvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbYAKJuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:50:54 -0500
Received: from www.tglx.de ([62.245.132.106]:39339 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbYAKJux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:50:53 -0500
Date: Fri, 11 Jan 2008 10:50:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <82e4877d0801101631w3679188ehffdf847a4825168a@mail.gmail.com>
Message-ID: <alpine.LFD.0.99999.0801111048550.5109@localhost.localdomain>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>  <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>  <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>  <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>
  <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net>  <82e4877d0712160543t2c7a03b1qb5c77ea6af59b5dd@mail.gmail.com>  <alpine.LFD.0.99999.0712170904120.3670@localhost.localdomain>  <82e4877d0712170508r69189409l803c8f490e65925d@mail.gmail.com> 
 <alpine.LFD.0.99999.0712172208500.3670@localhost.localdomain>  <alpine.LFD.0.99999.0801091248310.31637@localhost.localdomain> <82e4877d0801101631w3679188ehffdf847a4825168a@mail.gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Parag Warudkar wrote:

> On Jan 9, 2008 6:56 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Can you apply the patch below + the debug patch which prints the timer
> > stats on softlockup and provide the output of this.
> 
> Applied to today's git and running for 21 hours - no recurrence yet
> even with 1.2 wakeups per second.
> 
> I will re-open this thread if it bites again.

Would be interesting which commit fixed that problem. I'm a bit
worried about self healing bugs.

	tglx
