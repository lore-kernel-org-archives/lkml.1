Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYKJJ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYKJJ4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYKJJzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:55:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:48725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYKJJzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:55:50 -0500
Message-ID: <49180510.5030008@kernel.org>
Date: Mon, 10 Nov 2008 01:55:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparse_irq aka dyn_irq v10
References: <20081107081249.GB4435@elte.hu> <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <49180418.1050306@kernel.org> <20081110095331.GC15237@elte.hu>
In-Reply-To: <20081110095331.GC15237@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> +#ifdef CONFIG_SPARSE_IRQ
>> +static void uv_ack_apic_wrapper(unsigned int irq, struct irq_desc **descp)
>> +#else
>> +static void uv_ack_apic_wrapper(unsigned int irq)
>> +#endif
> 
> hm, why not change it to the new prototype unconditionally? (just pass 
> in NULL or so)

that is sitting on irq_chip, and if change that, we need to go over all those kind of funcs and structure of other platforms.

YH
