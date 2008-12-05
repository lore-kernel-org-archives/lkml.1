Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbYLEItc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbYLEItc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYLEItX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:49:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49354
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbYLEItW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:49:22 -0500
Date: Fri, 05 Dec 2008 00:49:22 -0800 (PST)
Message-Id: <20081205.004922.244597525.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205084233.GE2030@elte.hu>
References: <20081205082431.GD2030@elte.hu>
	<20081205.002701.172921476.davem@davemloft.net>
	<20081205084233.GE2030@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Dec 2008 09:42:33 +0100

> Please let me repeat: it's a _fundamental_ thesis of performance 
> instrumentation to not disturb the monitored context. Your insistence on 
> _stopping_ the monitored task breaks that fundamental axiom!

This is only a problem if you make your measurement quantums too
small.

Furthermore, there are multiple registers and states to update
atomically when a perf counter overflows.  You're read/write thing
just doesn't cut it, especially for certain kinds of hardware.

It's really a utopian view of the world. :)

