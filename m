Return-Path: <linux-kernel-owner+w=401wt.eu-S1763213AbZE1TlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763213AbZE1TlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZE1TlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:41:04 -0400
Received: from fifo99.com ([67.223.236.141]:33669 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbZE1TlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:41:03 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
	fallback sched_clock().
From: Daniel Walker <dwalker@fifo99.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <20090528193458.GA1122@linux-sh.org>
References: <1243527218.28705.35.camel@desktop>
	 <1243528329.6645.77.camel@laptop> <20090528164011.GA30104@linux-sh.org>
	 <1243529547.28705.43.camel@desktop> <20090528165816.GA31688@linux-sh.org>
	 <1243532324.28705.75.camel@desktop> <20090528175341.GA32118@linux-sh.org>
	 <1243534252.28705.86.camel@desktop> <20090528182730.GA32767@linux-sh.org>
	 <1243537463.28705.94.camel@desktop>  <20090528193458.GA1122@linux-sh.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 12:41:03 -0700
Message-Id: <1243539663.28705.99.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 04:34 +0900, Paul Mundt wrote:
> > I'm still a little confused how kernel modules fit in here.. Are you
> > saying a user would unload some certain driver which has a pin locked
> > down and prevents the clocksource from working. Then the user would load
> > the clocksource module which would now function, and that all would have
> > to happen in order to enter a certain power state?
> > 
> Yes.

I'm assuming this isn't a low power state, this would be something more
like suspend or hibernate right?

Daniel

