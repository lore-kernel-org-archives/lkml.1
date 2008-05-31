Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYEaKTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYEaKTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYEaKS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:18:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYEaKS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:18:58 -0400
Date: Sat, 31 May 2008 12:18:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
Message-ID: <20080531101832.GA15170@elte.hu>
References: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0050]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Despite looking quite innocent, this is the most intrusive 
> modification in the series.  I tested this change (on top of all the 
> other 14 ones) with as many variations of interrupt wiring 
> configuration as I could imagine and simulate with my system.  Of 
> course my machine is perfectly unbroken, :) so chances are more exotic 
> convolutions may have escaped my attention.  Also I tested the 32-bit 
> variation only.  So again, I recommend a good amount of testing in the 
> field before this patch is propagated upstream.

applied all 15 APIC patches of yours to tip/x86/apic, thanks Maciej!

	Ingo
