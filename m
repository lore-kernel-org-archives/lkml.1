Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZBKJvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZBKJvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZBKJvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:51:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbZBKJvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:51:18 -0500
Date: Wed, 11 Feb 2009 10:51:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: apic cleanups
Message-ID: <20090211095102.GC20518@elte.hu>
References: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
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


* Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> wrote:

> Hi all,
> 
> This series of patches (against tip/x86/apic) makes some fairly
> uncontroversial changes and cleanups to lay the groundwork for some more
> Xen-specific patches (which will no doubt cause more of a discussion).
> 
> These changes can also be pulled from
>    git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/apic
> 
> Thanks,
> 	J
> 
> Ian Campbell (1):
>   xen: expose enable_IO_APIC for 32-bit
> 
> Jeremy Fitzhardinge (4):
>   x86: make apic_* operations inline functions
>   x86: unstatic mp_find_ioapic so it can be used elsewhere
>   x86: add mp_find_ioapic_pin
>   x86: unstatic ioapic entry funcs
> 
>  arch/x86/include/asm/apic.h    |   35 +++++++++++++++++++++++++++++------
>  arch/x86/include/asm/hw_irq.h  |    2 --
>  arch/x86/include/asm/io_apic.h |    6 ++++++
>  arch/x86/include/asm/mpspec.h  |    2 ++
>  arch/x86/kernel/acpi/boot.c    |   18 ++++++++++++++----
>  arch/x86/kernel/io_apic.c      |   10 +++++-----
>  6 files changed, 56 insertions(+), 17 deletions(-)

Pulled into tip:x86/apic, thanks guys!

	Ingo
