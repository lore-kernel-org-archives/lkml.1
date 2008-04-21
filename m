Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYDUOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYDUOcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYDUOcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:32:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55834 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYDUOcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:32:05 -0400
Date: Mon, 21 Apr 2008 16:31:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080421143145.GW9554@elte.hu>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <480AB88C.1050900@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480AB88C.1050900@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Sandeen <sandeen@sandeen.net> wrote:

> > and we've conducted tens of thousands of bootup tests with all sorts 
> > of drivers and kernel options enabled and have yet to see a single 
> > crash due to 4K stacks.
> 
> Really, not one?
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=247158
> https://bugzilla.redhat.com/show_bug.cgi?id=227331
> https://bugzilla.redhat.com/show_bug.cgi?id=240077
> 
> (hehe, ok, xfs is a common component there...)
> 
> and it's not always obvious that you've overflowed the stack.
> 
> CONFIG_DEBUG_STACKOVERFLOW isn't ery useful because the warning printk 
> it generates uses the remaining amount of stack, and tips the box.

note that in -rt we have an ftrace plugin that measures _precise_ stack 
footprint, when it happens.

so it's possible to measure exact stack footprint and save a stack trace 
when that happens.

	Ingo
