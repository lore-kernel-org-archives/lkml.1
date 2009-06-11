Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZFKUKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZFKUKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZFKUK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:10:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbZFKUK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:10:29 -0400
Date: Thu, 11 Jun 2009 13:09:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: hch@infradead.org, a.p.zijlstra@chello.nl,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>, eranian@googlemail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulus@samba.org, tglx@linutronix.de
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <20090611125804.411095e8.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0906111305470.3535@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org>
 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <20090611125804.411095e8.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Andrew Morton wrote:
> 
> It could be that shipping userspace code in the kernel bundle will
> improve that situation.  So let's give it a try.  If it turns out to be
> good, let's do it again.  If it turns out to be bad, let's move perf
> out of the kernel tree and not do it again.

Exactly. Right now, I use the oprofile experience as a reason for why we 
should try to do this. But hey, who knows, in one year, maybe people will 
use _this_ experience as a reason why we should never do it again.

We just don't know yet. But that's no reason not to try. Either way, we'll 
hopefully learn something.

Or to quote Edison:
 "I have not failed 700 times. I have not failed once. I have succeeded in 
  proving that those 700 ways will not work. When I have eliminated the 
  ways that will not work, I will find the way that will work."

			Linus
