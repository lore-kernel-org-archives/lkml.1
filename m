Return-Path: <linux-kernel-owner+w=401wt.eu-S1764684AbXKTWBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764684AbXKTWBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762623AbXKTWBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:01:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42688 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbXKTWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:01:28 -0500
Date: Tue, 20 Nov 2007 13:58:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071120135839.08837372@laptopd505.fenrus.org>
In-Reply-To: <47433D63.5080806@rtr.ca>
References: <47425EA5.7000607@rtr.ca>
	<200711201837.39664.nickpiggin@yahoo.com.au>
	<20071120064747.2a8036cd@laptopd505.fenrus.org>
	<200711210243.46944.nickpiggin@yahoo.com.au>
	<20071120110726.4cc2995e@laptopd505.fenrus.org>
	<47433D63.5080806@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 15:02:43 -0500
Mark Lord <lkml@rtr.ca> wrote:
> ..
> 
> Well, for my dualCore notebook, dualCore MythTV box, and QuadCore
> desktop, the behaviour of the existing, working, 32-bit kernel
> IRQBALANCE code outperforms the userspace utility.
> 
> Mostly, I suspect, due to it's much faster response to changing
> conditions. That's something the external one could try to match, but
> at present it seems tuned specifically for high-traffic network
> servers, not for the average notebook or desktop.

I'd really like to see what it's doing before commenting on this;
at minimum can you give me the /proc/interrupts of the system?
It might a simple bug or simple missing item, not a total "scratch the
full system".


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
