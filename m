Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYFHITO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYFHITO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 04:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYFHIS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 04:18:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbYFHISy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 04:18:54 -0400
Date: Sun, 8 Jun 2008 10:18:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: NMI watchdog downgrade changes
Message-ID: <20080608081826.GA20033@elte.hu>
References: <Pine.LNX.4.55.0806060311510.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806060311510.2875@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> Ingo,
> 
>  This is a series of patches in response to your earlier report to fix 
> the problem where the I/O APIC NMI watchdog is attempted where it 
> should not be, fails and then disables the timer leading the system to 
> a fatal failure.  Please put in tip/x86/apic, replacing the patch 
> named nosmp-watchdog or 'x86: APIC/SMP: Downgrade the NMI watchdog for 
> "nosmp"' in the sequence.

applied, thanks Maciej. This series resolved another nmi_watchdog 
related boot failure i found today.

	Ingo
