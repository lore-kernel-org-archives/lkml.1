Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbZAPMqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbZAPMqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZAPMqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:46:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765AbZAPMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:46:21 -0500
Date: Fri, 16 Jan 2009 13:45:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fully honor "nolapic" (take 2)
Message-ID: <20090116124548.GC5421@elte.hu>
References: <4970818A.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4970818A.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> +	if (disable_apic) {
> +#ifdef CONFIG_X86_IO_APIC
> +		disable_ioapic_setup();
> +#endif
> +		return;
> +	}

Shouldnt that #ifdef be avoided by always providing the function - just it 
is a NOP inline in the !CONFIG_X86_IO_APIC case?

	Ingo
