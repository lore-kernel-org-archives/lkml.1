Return-Path: <linux-kernel-owner+w=401wt.eu-S1750875AbZHJSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbZHJSwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZHJSwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:52:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZHJSwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:52:17 -0400
Date: Mon, 10 Aug 2009 20:51:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: [patch 2/2] x86: arch specific support for remapping HPET MSIs
Message-ID: <20090810185156.GC9601@elte.hu>
References: <20090804190729.477649000@intel.com> <20090804190729.630510000@intel.com> <20090808151254.GC28892@elte.hu> <1249923516.27006.10839.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249923516.27006.10839.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Sat, 2009-08-08 at 08:12 -0700, Ingo Molnar wrote:
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > > x86 arch support for remapping HPET MSI's by associating the HPET 
> > > timer block with the interrupt-remapping HW unit and setting up 
> > > appropriate irq_chip
> > 
> > interesting. This means we'd materially utilize the irq-remapper 
> > not just on relatively obscure, virtualization related setups, 
> > but also in the native x86 bootup mode, on all (hpet+remap 
> > capable) Linux systems?
> 
> Ingo, For native linux kernel, interrupt-remapping allows simple 
> and reliable irq migration from the process context (in addition 
> to its need for supporting cpu's capable of x2apic). And as such 
> solves the issues we had in the past with cpu hotplug and irq 
> migration.

It's something much more directly useful than a fix for race 
conditions, and it would be used in a broader range of hardware
than x2apic. (Not to denounce its other uses - i was just upbeat 
about it getting even more mainstream use.)

	Ingo
