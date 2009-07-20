Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZGTKLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZGTKLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZGTKLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:11:45 -0400
Received: from www.tglx.de ([62.245.132.106]:48202 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbZGTKLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:11:45 -0400
Date: Mon, 20 Jul 2009 12:09:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Barry Song <21cnbao@gmail.com>
cc: mingo@redhat.com, dahlmann.thomas@arcor.de,
       LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Delete redundant IRQ_DISABLED check in irq_thread
In-Reply-To: <3c17e3570907192052n4cac97b9s64c9246af2809258@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0907201207050.11571@localhost.localdomain>
References: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>  <alpine.LFD.2.00.0907171523100.11571@localhost.localdomain>  <3c17e3570907170758g337703b7l12e1c262d6f385bf@mail.gmail.com>  <alpine.LFD.2.00.0907171730070.11571@localhost.localdomain>
 <3c17e3570907192052n4cac97b9s64c9246af2809258@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009, Barry Song wrote:

Can you please stop top posting and keeping the whole previous mail
for no value ?

> Another question, is it possible the irq thread run from a different
> CPU with the hardirq?  If so, even in your patch, the
> desc->thread_eoi(action->irq, desc) run on another CPU, maybe it can't
> unmask the original CPU interrupt. Then the device will not work
> later.

Sorry, I do not understand your question. Can you please explain ?

Thanks,

	tglx
