Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbXJXMCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbXJXMCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXJXMCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:02:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbXJXMCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:02:11 -0400
Date: Wed, 24 Oct 2007 14:01:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/12] X86: fix !CONFIG_SMP warning in processor.c
Message-ID: <20071024120148.GA21681@elte.hu>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Fix !CONFIG_SMP warning:
> 
> arch/x86/kernel/acpi/processor.c: In function ‘arch_acpi_processor_init_pdc’:
> arch/x86/kernel/acpi/processor.c:65: warning: unused variable ‘cpu’

thanks, applied.

	Ingo
