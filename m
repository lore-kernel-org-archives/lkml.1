Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZJLU1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZJLU1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZJLU1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:27:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33091 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682AbZJLU1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:27:04 -0400
Date: Mon, 12 Oct 2009 22:26:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] fix typo in nmi.c of apic
Message-ID: <20091012202613.GB7648@elte.hu>
References: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com> <alpine.LSU.2.00.0910091706350.19284@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910091706350.19284@wotan.suse.de>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 11 Sep 2009, Luming Yu wrote:
> 
> > I came across x86/kernel/apic/nmi.c and found several typo.
> > It's trivial in terms of doing nothing on changing execution logic.
> > 
> > Please review. If make sense, please apply.
> 
> Hi,
> 
> I'd rather go this through x86 tree. Adding Ingo.
> 
> > Ps. The patch is enclosed in attachment. The inline one
> > is c&p of it for reading.
> > 
> > 
> > Thanks,
> > Luming
> > 
> > Signed-off-by: Yu Luming <luming.yu@intel.com>
> > 
> >  nmi.c |   18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> > index b3025b4..9ff1f6d 100644
> > --- a/arch/x86/kernel/apic/nmi.c
> > +++ b/arch/x86/kernel/apic/nmi.c
> > @@ -121,7 +121,7 @@ static void report_broken_nmi(int cpu, unsigned
> > int *prev_nmi_count)
> >  	atomic_dec(&nmi_active);
> >  }
> > 
> > -static void __acpi_nmi_disable(void *__unused)
> > +static void __apic_nmi_disable(void *__unused)

that's correctly named, as a 'git grep acpi_nmi_disable' should reveal.

	Ingo
