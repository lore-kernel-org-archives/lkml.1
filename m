Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZFWJEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZFWJEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbZFWJEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:04:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241AbZFWJEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:04:42 -0400
Date: Tue, 23 Jun 2009 11:03:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Feng Tang <feng.tang@intel.com>
Cc: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090623090347.GA21616@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com> <20090623075643.GC6397@elte.hu> <20090623163246.1cdf755e@feng-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623163246.1cdf755e@feng-desktop>
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


* Feng Tang <feng.tang@intel.com> wrote:

> On Tue, 23 Jun 2009 15:56:43 +0800
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> 
> > >
> > > +#ifdef CONFIG_X86_LOCAL_APIC
> > > +static u64 sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
> > > +#endif
> > 
> > if SFI adds a 'depends on X86_LOCAL_APIC' the ugly #ifdef can be
> > dropped.
> 
> When Len designed the SFI spec, he considered the possibility of 
> being used by multiple archs, so we chose not to add a x86 
> dependency, though adding these
> #ifdef does make code ugly :P

But the file i commented on is arch/x86/kernel/sfi.c, not 
drivers/sfi/.

Those #ifdefs arent _that_ bad (and are used elsewhere in x86 code 
too) - but generally some effort should be spent in new code on 
trying to eliminate them.

> > In general, nice stuff - basically SFI is cleanly implemented 
> > ACPI tables without any of the run-code-in-acpi-tables 
> > complications, right?
> 
> Thanks for the comments, I really got inspired :). The expectation 
> for SFI is to be able to run cleanly with CONFIG_ACPI=n, and it 
> works fine on some intel platform.

Ok, cool!

	Ingo
