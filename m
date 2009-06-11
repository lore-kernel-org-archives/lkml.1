Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbZFKQz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbZFKQz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZFKQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:55:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbZFKQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:55:15 -0400
Date: Thu, 11 Jun 2009 09:54:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <20090611164656.GA12202@infradead.org>
Message-ID: <alpine.LFD.2.01.0906110952460.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <1244738098.27363.36.camel@violet> <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
 <20090611164656.GA12202@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Christoph Hellwig wrote:
> 
> Did you take a look a tools/perf/?  There is nothing close to hardware
> at all.  It's all pretty highly abstracted away from anything resembling
> the hardware through the perfcounters interface.

The thing is, the raw perfcounters interface isn't going to be useful as 
is. And I have seen where things go when you split them up. So when I get 
the choice, I'll go down the road of unproven failure, in the hope that it 
will be successful, rather than doing the same mistake once more.

   "Insanity: doing the same thing over and over, expecting to get 
    different results."

And I'm not insane.

Anyway, feel free to disagree. I just don't care. 

			Linus
