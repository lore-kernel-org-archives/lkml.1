Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbYF2UDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbYF2UDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbYF2UCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:02:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYF2UCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:02:52 -0400
Date: Sun, 29 Jun 2008 22:02:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080629200210.GB31633@elte.hu>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806291600.29059.rjw@sisk.pl> <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl> <200806292123.16237.rjw@sisk.pl> <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  You may argue this is a regression, but this is simply the cost paid 
> for progress -- the kernel stays within the spec as defined both by 
> ACPI and MPS, we have just started using a different configuration now 
> and an interrupt source override provided by the manufacturer 
> explicitly states INTIN2 is good to use.  In a sense you were simply 
> lucky previously the kernel was bad enough with the way it configured 
> the timer through the I/O APIC it failed completely avoiding the bug 
> in your firmware.  Now the bug has got uncovered.

well as long as we eliminate the bad effects around via DMI exceptions 
nobody will feel the need to argue whether it's a regression ;-) [this 
problem could be argued to be a regression, even if it's caused by prior 
luck/stupidity of Linux. We have to live with the effects of our 
mistakes.]

	Ingo
