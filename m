Return-Path: <linux-kernel-owner+w=401wt.eu-S1764866AbYFFUz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866AbYFFUz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbYFFUzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:55:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53946 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbYFFUzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:55:39 -0400
Date: Fri, 6 Jun 2008 13:55:32 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Top kernel oopses/warnings for the week of Friday June 6th,
 2008
Message-ID: <20080606135532.0dd2b2f6@linux.intel.com>
In-Reply-To: <alpine.LFD.1.10.0806062234420.3235@apollo.tec.linutronix.de>
References: <484988C8.1080105@linux.intel.com>
	<alpine.LFD.1.10.0806062234420.3235@apollo.tec.linutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 22:37:50 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 6 Jun 2008, Arjan van de Ven wrote:
> > 
> > Rank 8: tick_broadcast_oneshot_control (deadlock)
> > 	Reported 95 times (315 total reports)
> > 	The deadlock/timeout detector triggers in this codepath
> > rather agressively. I'm hesitant
> > 	to pin this one on bad hardware, it's happening too
> > repeastedly too much.
> > 	This deadlock was last seen in version 2.6.25.3, and first
> > seen in 2.6.24-rc4.
> > 	More info:
> > http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control
> 
> Is there a way to tell on which kind of systems this shows
> up ?

https://bugzilla.redhat.com/show_bug.cgi?id=444059
https://bugzilla.redhat.com/show_bug.cgi?id=442920

either one of those persons might be willing to help;)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
