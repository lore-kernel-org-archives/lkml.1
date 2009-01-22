Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZAVCfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZAVCfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZAVCfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:35:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:42269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZAVCfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:35:31 -0500
Message-ID: <4977DB47.7040805@kernel.org>
Date: Wed, 21 Jan 2009 18:34:47 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mpm@selenic.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: sparc64 build breakage...
References: <20090121.171553.142827920.davem@davemloft.net>
In-Reply-To: <20090121.171553.142827920.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> This change:
> 
> commit d7e51e66899f95dabc89b4d4c6674a6e50fa37fc
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Wed Jan 7 15:03:13 2009 -0800
> 
>     sparseirq: make some func to be used with genirq
> 
> breaks the sparc64 build:
> 
> arch/sparc/kernel/irq_64.c: In function ‘show_interrupts’:
> arch/sparc/kernel/irq_64.c:188: error: ‘struct kernel_stat’ has no member named ‘irqs’
> make[1]: *** [arch/sparc/kernel/irq_64.o] Error 1
> 


sorry, i missed it. we didn't touch m68k, s390, sparc...
but forget sparc64 sparc are merged already.

arch/sparc/kernel/irq_32.c:                                 kstat_cpu(j).irqs[i]);
arch/sparc/kernel/irq_32.c:     kstat_cpu(cpu).irqs[irq]++;
arch/sparc/kernel/irq_32.c:     kstat_cpu(cpu).irqs[irq]++;
arch/sparc/kernel/irq_64.c:                     seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
arch/sparc/kernel/sun4d_irq.c:                         kstat_cpu(cpu_logical_map(x)).irqs[i]);
arch/sparc/kernel/sun4d_irq.c:  kstat_cpu(cpu).irqs[irq]++;

YH
