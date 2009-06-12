Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZFLEGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZFLEGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZFLEGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:06:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33964 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZFLEGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:06:15 -0400
Date: Fri, 12 Jun 2009 05:05:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090612040558.GD8633@ZenIV.linux.org.uk>
References: <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611212635.GA9446@uranus.ravnborg.org> <4A3182C6.803@gmail.com> <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain> <20090611231952.GX8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906111624320.3237@localhost.localdomain> <20090612002634.GY8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906111955120.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111955120.3237@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 07:58:37PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 12 Jun 2009, Al Viro wrote:
> > 
> > So could you please clarify the situation?  If the ABI compatibility
> > requirements remain the same as they used to be, whether the userland code
> > is in-tree or not, I'm fine with the entire thing.  If they do not (and *ONLY*
> > in that case), I think we have a real problem.
> 
> I think the ABI requirements are the same.

OK, then.

> That said, I also suspect that as with oprofile itself, we'll end up 
> having expansions of the ABI that may well be CPU-specific. I also suspect 
> that there will probably be breakage early on just because things will 
> inevitably settle. 
> 
> And I think that for something like a profiling tool, such breakage is 
> much more acceptable than for the actual binaries you'd profile. It's not 
> like we're talking about breaking the boot or functionality of a machine, 
> as happens when we break the X server (which has happened).

Sure.
