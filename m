Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYEJNSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYEJNSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 09:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYEJNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 09:18:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46552 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbYEJNSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 09:18:12 -0400
Date: Sat, 10 May 2008 15:17:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Travis <travis@sgi.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080510131752.GA888@elte.hu>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu> <1210342946.3069.4.camel@localhost.localdomain> <20080509144722.GA20566@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509144722.GA20566@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I already told you that this was incorrect.  This is what I sent as 
> > the replacement on 28 April and I didn't hear back from you.
> > 
> > http://marc.info/?l=linux-kernel&m=120941111400620
> 
> ok - picked it up for testing - could you please send a signoff line 
> as well?

Alexey, the patch from James failed in testing on visws:

 arch/x86/kernel/built-in.o: In function `init_apic_mappings':
 : undefined reference to `boot_cpu_physical_apicid'
 arch/x86/kernel/built-in.o: In function `init_apic_mappings':
 : undefined reference to `boot_cpu_physical_apicid'
 arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
 : undefined reference to `boot_cpu_physical_apicid'
 arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':

config is at:

  http://redhat.com/~mingo/misc/config-Sat_May_10_15_05_47_CEST_2008.bad

	Ingo
