Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXCUON5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXCUON5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXCUON5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:13:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXCUON4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:13:56 -0400
Date: Wed, 21 Mar 2007 15:09:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Prechtel <stefan.prechtel@googlemail.com>, Andi Kleen <ak@suse.de>,
       Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] i386: disable local apic timer via command line or dmi quirk
Message-ID: <20070321140930.GA5717@elte.hu>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com> <200703211137.10884.ak@suse.de> <1174475666.10840.44.camel@localhost.localdomain> <200703211342.59093.ak@suse.de> <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com> <1174486483.10840.89.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174486483.10840.89.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The local APIC timer stops to work in deeper C-States. This is handled 
> by the ACPI code and a broadcast mechanism in the clockevents / tick 
> managment code.
> 
> Some systems do not expose the deeper C-States to the kernel, but 
> switch into deeper C-States behind the kernels back. This delays the 
> local apic timer interrupts for ever and makes the systems unusable.
> 
> Add a command line option to disable the local apic timer and a dmi 
> quirk for known broken systems.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Ingo Molnar <mingo@elte.hu>

nice work!

	Ingo
