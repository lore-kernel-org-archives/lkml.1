Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXKTEPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXKTEPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbXKTEPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:15:43 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:50674 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752655AbXKTEPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:15:42 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: Mark Lord <lkml@rtr.ca>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Date: Tue, 20 Nov 2007 06:15:50 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071109.734585)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47425EA5.7000607@rtr.ca>
In-Reply-To: <47425EA5.7000607@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711200615.51316.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday 20 November 2007 Tarihinde 06:12:21 yazmıştı:
> On 32-bit x86, we have CONFIG_IRQBALANCE available,
> but not on 64-bit x86.  Why not?
>
> I ask, because this feature seems almost essential to obtaining
> reasonable latencies during heavy I/O with fast devices.
>
> My 32-bit Core2Duo MythTV box drops audio frames without it,
> but works perfectly *with* IRQBALANCE.
>
> My QuadCore box works very well in 32-bit mode with IRQBALANCE,
> but responsiveness sucks bigtime when run in 64-bit mode (no IRQBALANCE)
> during periods of multiple heavy I/O streams (USB flash drives).
>
> That's with both the 32 and 64 bit versions of Kubuntu Gutsy,
> so the software uses pretty much identical versions either way.
>
> As near as I can tell, when IRQBALANCE is not configured,
> all I/O device interrupts go to CPU#0.
>
> I don't think our CPU scheduler takes that into account when assigning
> tasks to CPUs, so anything sent to CPU0 runs with very high latencies.
>
> Or something like that.
>
> Why no IRQ_BALANCE in 64-bit mode ?

Have you tried running irqbalance on userspace? Checkout 
http://irqbalance.org/ . AFAIK CONFIG_IRQBALANCE is deprecated and eats 
battery power.

Regards,
ismail

-- 
Faith is believing what you know isn't so -- Mark Twain
