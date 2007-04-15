Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbXDOESY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbXDOESY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 00:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXDOESX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 00:18:23 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1704 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXDOESX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 00:18:23 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 14 Apr 2007 21:18:16 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070415040126.GF8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704142110360.2847@alien.or.mcafeemobile.com>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com>
 <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
 <20070415040126.GF8915@holomorphy.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007, William Lee Irwin III wrote:

> The two basic attacks on such large priority spaces are the near future
> vs.  far future subdivisions and subdividing the priority space into
> (most often regular) intervals. Subdividing the priority space into
> intervals is the most obvious; you simply use some O(lg(n)) priority
> queue as the bucket discipline in the "time ring," queue by the upper
> bits of the queue priority in the time ring, and by the lower bits in
> the O(lg(n)) bucket discipline.

Sure. If you really need sub-millisecond precision, you can replace the 
bucket's list_head with an rb_root. It may be not necessary though for a 
cpu scheduler (still, didn't read Ingo's code yet).


- Davide


