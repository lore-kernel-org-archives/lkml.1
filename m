Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbZFLDAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbZFLDAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbZFLC7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 22:59:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbZFLC7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 22:59:52 -0400
Date: Thu, 11 Jun 2009 19:58:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <20090612002634.GY8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0906111955120.3237@localhost.localdomain>
References: <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611212635.GA9446@uranus.ravnborg.org>
 <4A3182C6.803@gmail.com> <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain> <20090611231952.GX8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906111624320.3237@localhost.localdomain> <20090612002634.GY8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, Al Viro wrote:
> 
> So could you please clarify the situation?  If the ABI compatibility
> requirements remain the same as they used to be, whether the userland code
> is in-tree or not, I'm fine with the entire thing.  If they do not (and *ONLY*
> in that case), I think we have a real problem.

I think the ABI requirements are the same.

That said, I also suspect that as with oprofile itself, we'll end up 
having expansions of the ABI that may well be CPU-specific. I also suspect 
that there will probably be breakage early on just because things will 
inevitably settle. 

And I think that for something like a profiling tool, such breakage is 
much more acceptable than for the actual binaries you'd profile. It's not 
like we're talking about breaking the boot or functionality of a machine, 
as happens when we break the X server (which has happened).

		Linus
