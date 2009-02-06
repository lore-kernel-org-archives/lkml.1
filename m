Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZBFPnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZBFPnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBFPmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:42:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbZBFPmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:42:53 -0500
Date: Fri, 6 Feb 2009 16:42:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Ed Swierk <eswierk@aristanetworks.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
Message-ID: <20090206154231.GN18368@elte.hu>
References: <1233765552.16414.6.camel@localhost.localdomain> <200902051705.33410.tvrtko.ursulin@sophos.com> <20090205180019.GC9233@elte.hu> <200902061130.05740.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902061130.05740.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:

> On Thursday 05 February 2009 18:00:19 Ingo Molnar wrote:
> > * Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> > > On Wednesday 04 February 2009 17:04:40 Ingo Molnar wrote:
> > > > 2) Please use vertical spaces when initializing structure fields.
> > > > Instead of the messy looking (and over-long-line generating) construct
> > > > of:
> > > >
> > > >         pci_mmcfg_config[0].address = (extcfg & 0x00007fff) << 25;
> > > >         pci_mmcfg_config[0].pci_segment = 0;
> > > >         pci_mmcfg_config[0].start_bus_number = 0;
> > > >         pci_mmcfg_config[0].end_bus_number = (1 << (8 - ((extcfg >> 28)
> > > > & 3))) - 1; pci_mmcfg_config_num = 1;
> > > >
> > > >    You will get something like:
> > > >
> > > >         config->address                 = (extcfg & 0x00007fff) << 25;
> > > >         config->pci_segment             = 0;
> > > >         config->start_bus_number        = 0;
> > > >         config->end_bus_number          = (1 << (8 - ((extcfg >> 28) &
> > > > 3)));
> > > >
> > > >         pci_mmcfg_config = config;
> > > >         pci_mmcfg_config_num = 1;
> > > >
> > > >    Which makes it more structured, more reviewable - and more pleasant
> > > > to look at as well.
> >
> > It is arch/x86/ and scheduler / etc. policy for new code - and we follow
> > that principle when we clean up code as well.
> 
> You also didn't say anything about variable declarations I asked about? 
> And I can add structure definition to that question as well.

Firstly, when posting on lkml please use proper line length breaks. Your 
email was almost unreadable in my mailer, so i had to stop reading it.

Also, i'm surprised you see the need to try to influence things here - i 
dont see a single upstream contribution from you in the past ~4 years of git 
log so how can you have any knowledge and experience about such details?

Both of those issues pretty materially weaken your standing to be taken 
seriously when it comes to fine details of Linux kernel coding style.

	Ingo
