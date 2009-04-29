Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbZD2UmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbZD2UmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZD2UmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:42:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZD2UmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:42:12 -0400
Date: Wed, 29 Apr 2009 22:41:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: using move_irq_desc
Message-ID: <20090429204135.GF21421@elte.hu>
References: <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org> <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu> <49F753DF.6040104@kernel.org> <20090429120056.GE11586@elte.hu> <49F87FF3.1090600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F87FF3.1090600@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> move_irq_desc will try to move irq_desc to node wanted if allocated one is not correct.
> (happen on device on different nodes that are using MSI, drivers are loaded and unloaded
> randomly)
> 
> [ Impact: make irq_desc go with device on node ]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/io_apic.c |    6 +-----
>  include/linux/irq.h            |    4 ++++
>  2 files changed, 5 insertions(+), 5 deletions(-)

applied, thanks. I'll look into merging it into the irq tree 
tomorrow and testing it.

	Ingo
