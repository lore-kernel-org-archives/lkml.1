Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbZFBM0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbZFBM0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZFBM0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:26:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZFBM0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:26:33 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090602075409.GA19294@linux-sh.org>
References: <20090602071718.GA17710@linux-sh.org>
	 <1243927502.23657.5619.camel@twins> <20090602073515.GB17710@linux-sh.org>
	 <1243928495.23657.5642.camel@twins>  <20090602075409.GA19294@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 14:26:25 +0200
Message-Id: <1243945585.23657.5934.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 16:54 +0900, Paul Mundt wrote:
> @@ -212,6 +213,7 @@ extern struct clocksource *clock;   /* current clocksource */
>  
>  #define CLOCK_SOURCE_WATCHDOG                  0x10
>  #define CLOCK_SOURCE_VALID_FOR_HRES            0x20
> +#define CLOCK_SOURCE_USE_FOR_SCHED_CLOCK       0x40

One more thing though, as John suggested, this bit might want a proper
comment explaining when a clocksource should and should not set this
bit.
