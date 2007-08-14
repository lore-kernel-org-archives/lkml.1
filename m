Return-Path: <linux-kernel-owner+w=401wt.eu-S942006AbXHNG2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942006AbXHNG2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXHNG1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:27:41 -0400
Received: from www.osadl.org ([213.239.205.134]:43040 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753449AbXHNG1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:27:39 -0400
Subject: Re: [PATCH] hres_timers_resume must block interrupts
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Korty <joe.korty@ccur.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1187069790.12828.131.camel@chaos>
References: <20070813232626.GA24938@tsunami.ccur.com>
	 <1187069790.12828.131.camel@chaos>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 08:27:36 +0200
Message-Id: <1187072856.12828.140.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 07:36 +0200, Thomas Gleixner wrote:
> On Mon, 2007-08-13 at 19:26 -0400, Joe Korty wrote:
> > Retrigger_next_event() must be called with interrupts disabled.
> > 
> > All internal (to hrtimer.c) uses of retrigger_next_event() are correct.
> > But the version exported to other files, hres_timers_resume(), does not
> > do the IRQ blocking, nor does the (single) external caller of it.
> > 
> > Rather than require that users of hres_timers_resume() do the IRQ blocking,
> > this patch makes the blocking part of the hres_timers_resume() functionality.
> 
> Ack.

-ENOTENOUGHCOFFEE. 

The resume functions are called with interrupts disabled. Nothing to fix
here.

	tglx


