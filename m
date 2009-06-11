Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbZFKTuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbZFKTuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZFKTuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:50:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbZFKTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:50:14 -0400
Date: Thu, 11 Jun 2009 12:49:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Newall <davidn@davidnewall.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <4A315C9F.8050908@davidnewall.com>
Message-ID: <alpine.LFD.2.01.0906111247270.3535@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>  <20090611161714.GA5008@infradead.org>  <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>  <20090611165226.GV8633@ZenIV.linux.org.uk>  <1244739378.6691.540.camel@laptop>  <20090611170015.GA3651@infradead.org>
  <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com> <4A3148AA.9000007@davidnewall.com> <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain> <4A314F37.2080202@davidnewall.com>
 <alpine.LFD.2.01.0906111142390.3573@localhost.localdomain> <4A3155E3.3030603@davidnewall.com> <alpine.LFD.2.01.0906111223250.3573@localhost.localdomain> <alpine.LFD.2.01.0906111226130.3573@localhost.localdomain> <4A315C9F.8050908@davidnewall.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, David Newall wrote:

> Linus Torvalds wrote:
> > To take the oprofile example that decided it for me: the code to actually 
> > support new processors was all done by basically kernel developers. And it 
> > didn't hit user land for almost a year, because the user-land tools didn't 
> > take the patch and propagate it up.
> 
> Bad developer, Spot, you only did half the job. Not sure there's much
> more one can say.

Umm. The kernel developer _did_ do the job. The patch to the user land 
side was available for that whole year. It just didn't get merged, and 
then didn't get merged some more, and then got merged but only in a SVN 
tree, not a release, and then finally when I did a bugzilla request to 
fedora, they took the patch and put it in their distro.

Anyway, it's clearly not worth discussing this with you. I've tried. I 
give up. Happily, I don't _need_ to convince you.

		Linus
