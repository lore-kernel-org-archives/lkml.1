Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYGMJpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYGMJpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYGMJow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:44:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYGMJov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:44:51 -0400
Date: Sun, 13 Jul 2008 11:44:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Recover timer_ack lost in the merge of the NMI
	watchdog
Message-ID: <20080713094434.GA32578@elte.hu>
References: <Pine.LNX.4.55.0807111936480.31940@cliff.in.clinika.pl> <20080711185511.GB17203@elte.hu> <Pine.LNX.4.55.0807130339010.6739@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807130339010.6739@cliff.in.clinika.pl>
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

> On Fri, 11 Jul 2008, Ingo Molnar wrote:
> 
> > i've applied your fixes to tip/x86/core:
> > 
> >  Maciej W. Rozycki (4):
> >       x86: L-APIC: Set IRQ0 as edge-triggered
> >       x86: L-APIC: Always fully configure IRQ0
> >       x86: I/O APIC: Never configure IRQ2
> >       x86: Recover timer_ack lost in the merge of the NMI watchdog
> 
> Thanks, please apply "x86: I/O APIC: Remove an IRQ2-mask hack" on top 
> of these.  Then what currently comprises 
> dmi_ignore_irq0_timer_override() can be done more properly as soon as 
> we know how to get information about INTIN0/2 configurations from the 
> SB400.  Furthermore, following considerations in the other mail, I 
> think the HPET driver should use the notion of ISA IRQ numbers by 
> mapping them appropriately from I/O APIC pin numbers.  Reusing 
> pin_2_irq() for this purpose seems a reasonable way of doing this to 
> me.

applied to tip/x86/core, thanks Maciej.

	Ingo
