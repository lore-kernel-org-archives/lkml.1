Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYHOI2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYHOI2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYHOI1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:27:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbYHOI1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:27:54 -0400
Date: Fri, 15 Aug 2008 10:27:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
Message-ID: <20080815082735.GC4776@elte.hu>
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 	fix the 32bit with bigsmp
> 	fix 64 bit with irq migration
> 	ordering functions in io_apic_xx.c
> 
> 
> to do:
>     merge io_apic_xx.c

applied to tip/irq/sparseirq - thanks Yinghai, great work!

What do you think about Eric's abstraction suggestion, that irq_desc's 
structure should be hidden from all but kernel/irq/* code. I think 
that's a sane suggestion. We do it in mm/slab.c too: no external code 
knows the structure of 'struct kmem_cache'.

	Ingo
