Return-Path: <linux-kernel-owner+w=401wt.eu-S934695AbXEHIcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695AbXEHIcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934688AbXEHIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:32:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:33613 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934687AbXEHIcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:32:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Wi1YbkJCWH3gJX1kGc08b+A5AeU26b44mLSmH5N
	oX5BIRgv+YDToA
Subject: Re: [patch] CFS scheduler, -v10
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
In-Reply-To: <1178610698.7558.48.camel@Homer.simpson.net>
References: <20070507163342.GA3502@elte.hu>
	 <1178610698.7558.48.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 08 May 2007 10:32:09 +0200
Message-Id: <1178613129.6181.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 09:51 +0200, Mike Galbraith wrote:

> When thud starts, chew takes a size 14EEE latency hit if bits 1, 2 and 3
> are set in sysctl_sched_load_smoothing.

Well shoot, I take it back.  I'm seeing it with 0x1 as well.

pid 6155, prio   0, out for   32 ms, ran for    4 ms, load  13%
pid 6155, prio   0, out for   24 ms, ran for    5 ms, load  19%
pid 6155, prio   0, out for    2 ms, ran for    4 ms, load  69%
pid 6155, prio   0, out for  760 ms, ran for 10031 ms, load  92%
pid 6155, prio   0, out for   32 ms, ran for    4 ms, load  13%
pid 6155, prio   0, out for   32 ms, ran for    4 ms, load  13%


