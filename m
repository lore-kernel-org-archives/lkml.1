Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZFKRIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZFKRIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbZFKRHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:07:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbZFKRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:07:52 -0400
Date: Thu, 11 Jun 2009 10:06:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Al Viro <viro@ZenIV.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <20090611170015.GA3651@infradead.org>
Message-ID: <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Christoph Hellwig wrote:
> 
> So what point is there in keeping it in-tree except making life hell for
> packagers?

Give it up. Packagers can trivially generate their own sub-packages. They 
do it all the time. They already do it for the user-mode header files, 
extracted from the kernel - something you've worked on yourself.

So your point is clearly bogus, and dishonest.

You haven't actually looked the real problem in the eye, and acknowledged 
the disaster that is oprofile. Let's give a _new_ approach a chance, and 
see if we can avoid the mistakes of yesteryear this time.

			Linus
