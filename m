Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZBSLah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZBSLah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZBSLa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:30:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58778 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZBSLa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:30:28 -0500
Date: Thu, 19 Feb 2009 12:30:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] decouple x2apic from irq remapping
Message-ID: <20090219113018.GS2354@elte.hu>
References: <20090218120051.GF26845@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218120051.GF26845@redhat.com>
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


* Gleb Natapov <gleb@redhat.com> wrote:

> Hi,
> 
> Currently x2apic is used only if interrupt remapping can be enabled,
> but if all apic ids are smaller then 255 there is no reason to
> enable interrupt remapping at all. Although there is not real HW that has
> x2apic but does not have IR the decoupling is useful since we want to
> emulate x2apic interface in KVM (it is more vitalization friendly), but
> we don't want to emulate IR just for that.
> 
> According to Intel docs BIOS should pass control to OS in x2apic mode 
> if there are apics with id > 255 and in xapic otherwise, so the proposed
> patch requires IR configuration only if BIOS switched apic to x2apic
> mode.
> 
> The patch is against tip:x86/apic.

Applied to tip:x86/apic, thanks Gleb!

	Ingo
