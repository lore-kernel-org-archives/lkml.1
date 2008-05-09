Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYEIOrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYEIOrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYEIOrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:47:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYEIOro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:47:44 -0400
Date: Fri, 9 May 2008 16:47:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Travis <travis@sgi.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080509144722.GA20566@elte.hu>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu> <1210342946.3069.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210342946.3069.4.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > >  /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
> > >   * by scheduler but indexed physically */
> > > -cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
> > > +static cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
> > 
> > i've got the one below queued up but it's stalled as it could easily be 
> > wrong and there's no ack from James yet and there's been discussion back 
> > and forth. James, what do you suggest?

> I already told you that this was incorrect.  This is what I sent as 
> the replacement on 28 April and I didn't hear back from you.
> 
> http://marc.info/?l=linux-kernel&m=120941111400620

ok - picked it up for testing - could you please send a signoff line as 
well?

Alexey, you moved those SMP variables, do you agree with the patch from 
James? (it looks good to me)

	Ingo
