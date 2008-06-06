Return-Path: <linux-kernel-owner+w=401wt.eu-S1750908AbYFFUnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbYFFUnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764919AbYFFUjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:39:04 -0400
Received: from www.tglx.de ([62.245.132.106]:37058 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763868AbYFFUjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:39:01 -0400
Date: Fri, 6 Jun 2008 22:37:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Top kernel oopses/warnings for the week of Friday June 6th,
 2008
In-Reply-To: <484988C8.1080105@linux.intel.com>
Message-ID: <alpine.LFD.1.10.0806062234420.3235@apollo.tec.linutronix.de>
References: <484988C8.1080105@linux.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Arjan van de Ven wrote:
> 
> Rank 8: tick_broadcast_oneshot_control (deadlock)
> 	Reported 95 times (315 total reports)
> 	The deadlock/timeout detector triggers in this codepath rather
> agressively. I'm hesitant
> 	to pin this one on bad hardware, it's happening too repeastedly too
> much.
> 	This deadlock was last seen in version 2.6.25.3, and first seen in
> 2.6.24-rc4.
> 	More info:
> http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control

Is there a way to tell on which kind of systems this shows up ?

I'm stll looking for someone having this problem, who is willing to go
through a meticulous debug session.

Thanks,

	tglx
