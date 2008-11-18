Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbYKRAME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbYKRAME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYKRALq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:11:46 -0500
Received: from ozlabs.org ([203.10.76.45]:43299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbYKRALp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:11:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18722.2107.970887.768477@cargo.ozlabs.ibm.com>
Date: Tue, 18 Nov 2008 11:11:39 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.LFD.2.00.0811171522030.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	<alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
	<1226963596.7178.254.camel@pasglop>
	<alpine.LFD.2.00.0811171522030.18283@nehalem.linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> > > It's made worse by the fact that they 
> > > also have horribly bad TLB fills on their broken CPU's, and years and 
> > > years of telling people that the MMU on ppc's are sh*t has only been 
> > > reacted to with "talk to the hand, we know better".
> > 
> > Who are you talking about here precisely ? I don't think either Paul or
> > I every said something nearly around those lines ... Oh well.
> 
> Every single time I've complained about it, somebody from IBM has said ".. 
> but but AIX".
> 
> This time it was Paul. Sometimes it has been software people who agree, 

Maybe I wasn't clear.  I was reporting the reaction I get from the
hardware designers, who often like to push off the hard problems to
software to fix.

Keep flaming, by the way.  It provides me with some amount of
assistance in my quest to get the hardware designers to do better. ;)

Also, you didn't respond to my comments about the purely software
benefits of a larger page size.

Paul.
