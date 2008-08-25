Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYHYNOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYHYNOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYHYNOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:14:06 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:7975 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbYHYNOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:14:05 -0400
Message-ID: <48B2B017.1040302@hp.com>
Date: Mon, 25 Aug 2008 09:13:59 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B2A91F.8000302@hp.com>
In-Reply-To: <48B2A91F.8000302@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding in SLUB debugging doesn't show anything new (I think). Example
boot log (w/ initcall_debug enabled) is at:

http://free.linux.hp.com/~adb/bug.11342/prob5.txt

This has happened 3 times in a row as well. Whilst this is being looked
at, I'm going to fast-forward ahead to the latest in Linus' tree, and
see if the problem is still occurring (I think Linus' point earlier
about some sort of rogue timing and/or corruption bug is spot on, but
it's probably better to see how close to "today's tree" I can reproduce
this). I'll also try kernels w/ the problematic merge patch backed out
to see if that still "fixes" (or more likely(?) just patches over the
real problem).

Alan
