Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbXDQGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbXDQGue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXDQGue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:50:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2867 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXDQGuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:50:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 16 Apr 2007 23:50:03 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nick Piggin <npiggin@suse.de>
cc: William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070417061503.GC1057@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org>
 <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au>
 <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de>
 <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de>
 <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Nick Piggin wrote:

> > All things are not equal; they all have different properties. I like
> 
> Exactly. So we have to explore those properties and evaluate performance
> (in all meanings of the word). That's only logical.

I had a quick look at Ingo's code yesterday. Ingo is always smart to 
prepare a main dish (feature) with a nice sider (code cleanup) to Linus ;)
And even this code does that pretty nicely. The deadline designs looks 
good, although I think the final "key" calculation code will end up quite 
different from what it looks now.
I would suggest to thoroughly test all your alternatives before deciding. 
Some code and design may look very good and small at the beginning, but 
when you start patching it to cover all the dark spots, you effectively 
end up with another thing (in both design and code footprint).
About O(1), I never thought it was a must (besides a good marketing 
material), and O(log(N)) *may* be just fine (to be verified, of course).



- Davide


