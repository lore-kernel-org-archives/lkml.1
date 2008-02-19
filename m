Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYBSOG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYBSOG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYBSOGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:06:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57301 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbYBSOGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:06:20 -0500
Date: Tue, 19 Feb 2008 15:05:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, jbohac@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
Message-ID: <20080219140552.GC9965@elte.hu>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de> <20080219100029.GA1637@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219100029.GA1637@elf.ucw.cz>
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

> TSC is used even on machines when CONFIG_X86_TSC is not set (X86_TSC 
> means _require_ TSC), but it is not properly disabled when it is 
> unusable, because acpi code understood the config switch as "may use 
> TSC".
> 
> This actually fixes suspend problems on my x60.

ah! This makes tons of sense. I've applied your patch - but i guess it 
should go via the ACPI tree.

	Ingo
