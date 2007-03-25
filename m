Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbXCYMxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbXCYMxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXCYMxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:53:32 -0400
Received: from www.osadl.org ([213.239.205.134]:51049 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753506AbXCYMxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:53:32 -0400
Subject: Re: [patch] ntp: avoid integer overflow in do_adjtimex()
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, john stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070325111420.GA16988@elte.hu>
References: <1174696834.5690.14.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703240153220.14457@scrub.home>
	 <20070325010903.a0e6e624.akpm@linux-foundation.org>
	 <1174820872.10840.494.camel@localhost.localdomain>
	 <20070325111420.GA16988@elte.hu>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 15:01:00 +0200
Message-Id: <1174827661.10840.514.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 13:14 +0200, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Here you go. It's ugly, but it should do the trick for now.
> > 
> > 	tglx
> 
> here's your patch with proper metadata:
> 
> --------------------->
> From: Thomas Gleixner <tglx@linutronix.de>
> Subject: [patch] ntp: avoid integer overflow in do_adjtimex()
> 
> John Stultz traced back ntpd problems to the following issue: 
> do_adjtimex() [used by ntpd] can overflow if there's a too long delay 
> between timer interrupts - as it can happen on NO_HZ. Expand the 
> time_adjust calculation/division from 32 bits to 64 bits.

Wrong metadata. This is a patch to fix John's patch vs. signedness.

	tglx



