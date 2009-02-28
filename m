Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZB1RP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZB1RP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZB1RPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:15:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40874 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZB1RPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:15:16 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
From: Andi Kleen <andi@firstfloor.org>
References: <20090226131336.423054348@linutronix.de>
	<20090226131719.760899560@linutronix.de>
	<20090226153216.5db66bc3.akpm@linux-foundation.org>
	<20090226212752.332ba546@infradead.org>
	<20090226214514.f8a58731.akpm@linux-foundation.org>
	<1235719113.4948.1252.camel@laptop>
	<20090226234800.4977fca5.akpm@linux-foundation.org>
Date: Sat, 28 Feb 2009 18:13:22 +0100
In-Reply-To: <20090226234800.4977fca5.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 26 Feb 2009 23:48:00 -0800")
Message-ID: <87ab8632od.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Given that this threaded-irq code appears to be new and not very tested
> in -rt, I think it would be a good idea to convert some popular drivers
> (e1000/e1000e) so that the core code gets a good thrashing before we
> merge it.

It's questionable it's a good idea for these kind of network drivers,
because the majority of work should be done in NAPI context anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
