Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYFRNOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYFRNOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYFRNOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:14:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYFRNOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:14:44 -0400
Date: Wed, 18 Jun 2008 15:14:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080618131409.GC11501@elte.hu>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <alpine.LFD.1.10.0806170905221.3395@apollo.tec.linutronix.de> <200806172244.24026.rjw@sisk.pl> <200806180019.49628.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806180019.49628.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Thanks, it eliminates the WARNING, but still the box doesn't work 
> > with the "x86: add C1E aware idle function" patch applied, even with 
> > 'highres=off'.
> > 
> > The main symptom is that CPU loads are computed incorrectly (I got X 
> > using 126% of CPU time from 'top', for example).  Apart from this, 
> > some processes (like gkrellm) seem to be 'frozen' and only change 
> > their state in 'jumps', as though they only got CPU from time to 
> > time at random.
> > 
> > Reverting the above-mentioned patch fixes those problems.
> 
> Ah.  If your fix is replaced with the appended one, the system happily 
> works with C1E and highres.

very nice! I have applied your fix to tip/x86/cpu.

does this resolve all problems on your box, or is the IO-APIC problem 
still open?

	Ingo
