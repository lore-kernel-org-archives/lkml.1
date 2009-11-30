Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZK3J3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZK3J3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZK3J3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:29:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50129 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZK3J3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:29:07 -0500
Date: Mon, 30 Nov 2009 10:28:49 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jamie Lokier <jamie@shareable.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@marvell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED
	registered with setup_irq
Message-ID: <20091130092849.GA6896@pengutronix.de>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de> <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain> <20091129023118.GA21529@shareable.org> <20091129102635.GA22653@pengutronix.de> <20091129151840.GA30813@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091129151840.GA30813@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jamie,

On Sun, Nov 29, 2009 at 03:18:40PM +0000, Jamie Lokier wrote:
> According to this thread, at the moment when you have multiple
> IRQF_DISABLED|IRQF_SHARED ISRs, only the first one is run with
> interrupts disabled.
No.  When you have multiple IRQF_SHARED ISRs *all* are run with irqs
disabled if the first has IRQF_DISABLED.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
