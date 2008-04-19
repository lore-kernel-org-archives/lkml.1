Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYDSOYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYDSOYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761702AbYDSOXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:23:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759339AbYDSOXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:23:45 -0400
Date: Sat, 19 Apr 2008 16:23:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080419142329.GA5339@elte.hu>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418142934.38ce6bf4.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> >  config 4KSTACKS
> >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > -	depends on DEBUG_KERNEL
> >  	depends on X86_32
> > +	default y
> 
> This patch will cause kernels to crash.

what mainline kernels crash and how will they crash? Fedora and other 
distros have had 4K stacks enabled for years:

  $ grep 4K /boot/config-2.6.24-9.fc9
  CONFIG_4KSTACKS=y

and we've conducted tens of thousands of bootup tests with all sorts of 
drivers and kernel options enabled and have yet to see a single crash 
due to 4K stacks. So basically the kernel default just follows the 
common distro default now. (distros and users can still disable it)

	Ingo
