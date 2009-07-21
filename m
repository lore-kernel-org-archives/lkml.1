Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZGUTvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZGUTvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZGUTvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:51:04 -0400
Received: from fifo99.com ([67.223.236.141]:40928 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbZGUTvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:51:03 -0400
Subject: Re: [RFC][patch 1/5] move clock source related code to
	clocksource.c
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090721192057.177653956@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192057.177653956@de.ibm.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 12:50:51 -0700
Message-Id: <1248205851.14209.777.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-move.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Move clock source related code from timekeeping.c to clocksource.c
> where they belong. The selected clocks source "clock" is now defined
> in clocksource.c and clocksource_init is added to set up the initial
> clock.

The problem is most (if not all) the code your moving is actually time
keeping code .. The reason it seems like clocksource code is cause John
wasn't very choosy about which structure he added variables too .. So
really this clean up needs to be in reverse, remove all the timekeeping
code from the clocksource code.

Daniel

