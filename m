Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYG1Okz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYG1Okz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYG1Okr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:40:47 -0400
Received: from www.tglx.de ([62.245.132.106]:43004 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbYG1Okq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:40:46 -0400
Date: Mon, 28 Jul 2008 16:39:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: 2.6.26-git8: spinlock lockup in c1e_idle()
In-Reply-To: <20080724032212.38c95250@gmail.com>
Message-ID: <alpine.LFD.1.10.0807281638170.14925@apollo.tec.linutronix.de>
References: <20080724032212.38c95250@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, Mikhail Kshevetskiy wrote:

> BUG: spinlock lockup on CPU#0, swapper/0, ffffffff805d7e60
> Pid: 0, comm: swapper Not tainted 2.6.26-git8 #6
> 
> Call Trace:
>  [<ffffffff803471f1>] _raw_spin_lock+0xdc/0x107
>  [<ffffffff80480170>] _spin_lock+0x55/0x62
>  [<ffffffff8025a303>] clockevents_notify+0x19/0x7a
>  [<ffffffff80213d40>] c1e_idle+0xf8/0x113
>  [<ffffffff80256770>] ? atomic_notifier_call_chain+0xf/0x11
>  [<ffffffff8020b2a7>] cpu_idle+0x88/0xee
>  [<ffffffff8046c392>] rest_init+0x86/0x8a
>  [<ffffffff80624e01>] start_kernel+0x399/0x3a4
>  [<ffffffff8062429f>] x86_64_start_reservations+0xa5/0xa9
>  [<ffffffff806243af>] x86_64_start_kernel+0xe9/0xf8

Mikhail,

we merged a patch which might be fixing that problem after
2.6.26-git8. Can you give Linus latest a try please ?

Thanks,

	tglx
