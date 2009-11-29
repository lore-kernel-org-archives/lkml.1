Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZK2CcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZK2CcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 21:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZK2Cb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 21:31:59 -0500
Received: from mail2.shareable.org ([80.68.89.115]:38525 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbZK2Cb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 21:31:59 -0500
Date: Sun, 29 Nov 2009 02:31:18 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered with setup_irq
Message-ID: <20091129023118.GA21529@shareable.org>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de> <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> What about analysing the code and verifying that the setup order is
> correct ?
> 
> Adding save/restore_irq just because you have no clue what the code
> does is utter nonsense.

Wouldn't it be quite a lot nicer if generic setup moved the
IRQF_DISABLED handler to be first in the list, if that actually works
in a useful way rather than simply being a quirk that irqs are
disabled for the first one?

-- Jamie
