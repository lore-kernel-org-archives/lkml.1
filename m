Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZB1LPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZB1LPD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 06:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZB1LOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 06:14:52 -0500
Received: from www.tglx.de ([62.245.132.106]:53313 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZB1LOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 06:14:51 -0500
Date: Sat, 28 Feb 2009 12:13:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl
Subject: Re: lockdep and threaded IRQs (was: ...)
In-Reply-To: <200902272046.50572.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0902281208270.29264@localhost.localdomain>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271830.37207.david-b@pacbell.net> <20090227183949.90f231e6.akpm@linux-foundation.org> <200902272046.50572.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009, David Brownell wrote:
>   drivers/mfd/twl4030-irq.c
> 
> Where you'll observe twl_init_irq() at line 688 setting
> up the thread and the Primary IRQ Handler (PIH) dispatch.
> That's pretty much bog-standard chained IRQ setup code,
> except that it chains through a thread.

So this would be the perfect candidate to test the generic threaded
code I posted a few days ago ?

Thanks,

	tglx
