Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYGRRbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYGRRbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYGRRbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:31:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYGRRbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:31:46 -0400
Date: Fri, 18 Jul 2008 19:31:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Assmann <sassmann@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Ihno Krumreich <ihno@suse.de>,
       Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
       Felix Foerster <ffoerster@suse.de>, Olaf Dabrunz <od@suse.de>
Subject: Re: [PATCH] Introduce config option for pci reroute quirks (was:
	[PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI)
Message-ID: <20080718173129.GP6875@elte.hu>
References: <12155255883170-git-send-email-od@suse.de> <20080713210133.GA12362@elte.hu> <200807140924.59023.jbarnes@virtuousgeek.org> <20080714164548.GA28499@elte.hu> <20080714164948.GA15153@suse.de> <20080714165823.GB15153@suse.de> <20080714175137.GA2297@suse.de> <487C8EA7.6020205@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487C8EA7.6020205@suse.de>
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


* Stefan Assmann <sassmann@suse.de> wrote:

> This is against linux-2.6-tip, branch pci-ioapic-boot-irq-quirks.
> 
> From: Stefan Assmann <sassmann@suse.de>
> Subject: Introduce config option for pci reroute quirks
> 
> The config option X86_REROUTE_FOR_BROKEN_BOOT_IRQS is introduced to 
> enable (or disable) the redirection of the interrupt handler to the 
> boot interrupt line by default. Depending on the existence of 
> interrupt masking / threaded interrupt handling in the kernel 
> (vanilla, rt, ...) and the maturity of the rerouting patch, users can 
> enable or disable the redirection by default.
> 
> This means that the reroute quirk can be applied to any kernel without 
> changing it.
> 
> Interrupt sharing could be increased if this option is enabled. 
> However this option is vital for threaded interrupt handling, as done 
> by the RT kernel. It should simplify the consolidation with the RT 
> kernel.
> 
> The option can be overridden by either pci=ioapicreroute or 
> pci=noioapicreroute.

applied, thanks Stefan.

	Ingo
