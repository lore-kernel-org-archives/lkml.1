Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXGJR2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXGJR2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761549AbXGJR1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:27:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47128 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760779AbXGJR1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:27:47 -0400
Subject: Re: clocksource change of behavior in 2.6.22 compared to 2.6.20
	causes massive system clock slowdown
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070710002935.f082b7c3.akpm@linux-foundation.org>
References: <5a4c581d0707090727q15eff62ax1fdb1271754cc2d2@mail.gmail.com>
	 <20070710002935.f082b7c3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 10:28:20 -0700
Message-Id: <1184088500.30575.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 00:29 -0700, Andrew Morton wrote:
> On Mon, 9 Jul 2007 16:27:59 +0200 "Alessandro Suardi" <alessandro.suardi@gmail.com> wrote:
> 
> > My oldish AMD K7-800's clock began falling behind after
> >  rebooting from 2.6.20 (and 109 days uptime with a spotless
> >  clock) into 2.6.22; time lost is about four minutes each hour.
> > 
> > Turns out that 2.6.22 marks my TSC as unstable and starts
> >  using PIT instead. Rebooting 2.6.22 with clocksource=tsc
> >  gets the original stable system time back.

Alessandro,
Can you send me dmesg output for 2.6.20 and 2.6.22 (without
clocksource=tsc)?

thanks
-john

