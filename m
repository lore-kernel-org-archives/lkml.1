Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXDQHV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXDQHV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXDQHV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:21:56 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3818 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXDQHVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:21:55 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Apr 2007 00:21:06 -0700 (PDT)
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
In-Reply-To: <20070417071126.GG1057@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0704170017010.30516@alien.or.mcafeemobile.com>
References: <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net>
 <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net>
 <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au>
 <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com>
 <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com>
 <20070417071126.GG1057@wotan.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Nick Piggin wrote:

> To be clear, I'm not saying O(logN) itself is a big problem. Type
> 
>   plot [10:100] x with lines, log(x) with lines, 1 with lines

Haha, Nick, I know how a log() looks like :)
The Time Ring I posted as example (that nothing is other than a 
ring-based bucket sort), keeps O(1) if you can concede some timer 
clustering.


- Davide


