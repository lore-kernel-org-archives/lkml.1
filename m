Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZFKSLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZFKSLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbZFKSK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:10:57 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:48876 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbZFKSK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:10:56 -0400
Message-ID: <4A3148AA.9000007@davidnewall.com>
Date: Fri, 12 Jun 2009 03:40:50 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
References: <20090611160329.GA3366@elte.hu>	 <20090611161714.GA5008@infradead.org>	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>	 <20090611165226.GV8633@ZenIV.linux.org.uk>	 <1244739378.6691.540.camel@laptop>	 <20090611170015.GA3651@infradead.org>	 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com>
In-Reply-To: <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> And really, what do we gain by moving perf out of tree and making it
> follow its own release cycle (and getting out of sync eventually)?

I'm sure perf will change, for example as faults are discovered in it. 
Perhaps, too, the kernel side counters will change, but will the ABI? 
Peter Zijlstra comment ("we most certainly intend to maintain its ABI")
implies it won't, or won't in such a way as to break user space tools.

What I'm saying is that this doesn't sound like something that needs
user-space in lock-step with kernel.
