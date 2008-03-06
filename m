Return-Path: <linux-kernel-owner+w=401wt.eu-S934080AbYCFNQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbYCFNQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYCFNQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:16:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYCFNQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:16:06 -0500
Date: Thu, 6 Mar 2008 14:15:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Message-ID: <20080306131547.GE21359@elte.hu>
References: <20080306102927.GA4434@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306102927.GA4434@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> On amd 8-core system, I get crash on boot... Last messages:
> 
> Quad-Core AMD Opteron...
> Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
> BUG: unable to handle kernel paging request at 00...005958
> IP: __alloc_pages+0x38
> ...
> Call trace:
> kmem_getpages
> cache_grow
> ____cache_alloc_node
> cpuup_callback
> kmem_cache_alloc_node
> cpuup_callback
> notifier_call_chain
> _cpu_up

could you try latest x86.git:

    http://people.redhat.com/mingo/x86.git/README

does it fix it? Could be one of the numa fixes that are queued up.

	Ingo
