Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYLEI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYLEI1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYLEI1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:27:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51345
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbYLEI1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:27:01 -0500
Date: Fri, 05 Dec 2008 00:27:01 -0800 (PST)
Message-Id: <20081205.002701.172921476.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205082431.GD2030@elte.hu>
References: <20081205081137.GB2030@elte.hu>
	<20081205.001717.216522767.davem@davemloft.net>
	<20081205082431.GD2030@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Dec 2008 09:24:31 +0100

> Right now we begun with the most trivial ones:
> 
>   enum perf_record_type {
>           PERF_RECORD_SIMPLE,
>           PERF_RECORD_IRQ,
>   };
> 
> ... but it would be natural to do a PERF_RECORD_GP_REGISTERS as well. 
> Perhaps even a PERF_RECORD_STACKTRACE using the sysprof facilities, to do 
> a hierarchic multi-dimension profile that sysprof does so nicely.

Maybe even add something like PERF_RECORD_THE_MOON...

see how rediculious this is?

It's not your business in the kernel to decide what things are
useful.  The monitor can stop the task and inspect whatever
it wants with _existing_ facilities.  We need none of this stuff.
