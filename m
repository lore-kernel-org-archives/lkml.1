Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbXGRG7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbXGRG7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXGRG7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:59:00 -0400
Received: from www.osadl.org ([213.239.205.134]:40581 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751311AbXGRG7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:59:00 -0400
Subject: Re: [PATCH] posix-timer: fix deletion race
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Katz <jeremy.katz@windriver.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
In-Reply-To: <1184738755.12353.481.camel@chaos>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
	 <1184662429.12353.426.camel@chaos>
	 <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
	 <1184703427.12353.476.camel@chaos>
	 <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
	 <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
	 <1184738755.12353.481.camel@chaos>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 08:58:58 +0200
Message-Id: <1184741938.12353.484.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 08:05 +0200, Thomas Gleixner wrote:
> On Tue, 2007-07-17 at 16:58 -0700, Jeremy Katz wrote:
> 
> > Scratch that.  I had infrastructure problems, and ended up using the wrong 
> > build.
> 
> > EFLAGS: 00010246   (2.6.22.1-WR1.4aq_cgl #2)
> 
> Hmm. Are there any other patches on that kernel ?
> 
> Is there a chance that you can whip up a test program which is not
> secret sauce ?
> 
> Also can you please enable CONFIG_PROVE_LOCKING, which might catch any
> locking problem, which might be related to this.

Another test: Can you please disable CONFIG_SCHED_SMT to narrow it down
further ?

	tglx


