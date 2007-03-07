Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXCGOic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXCGOic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030630AbXCGOic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:38:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:19807 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030628AbXCGOia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:38:30 -0500
Message-ID: <45EECE5C.6030100@ru.mvista.com>
Date: Wed, 07 Mar 2007 17:38:20 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: mingo@elte.hu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/6 -rt] powerpc 2.6.20-rt8: to convert spinlocks to raw
 ones.
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi649d25qz.wl@toshiba.co.jp>
In-Reply-To: <yyi649d25qz.wl@toshiba.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tsutomu OWA wrote:

> --- linux-rt8/arch/powerpc/kernel/irq.c	2007-02-20 14:30:38.000000000 +0900
> +++ rt/arch/powerpc/kernel/irq.c	2007-03-05 18:54:34.000000000 +0900
> @@ -392,7 +392,7 @@ EXPORT_SYMBOL(do_softirq);
>  #ifdef CONFIG_PPC_MERGE
>  
>  static LIST_HEAD(irq_hosts);
> -static spinlock_t irq_big_lock = SPIN_LOCK_UNLOCKED;
> +static DEFINE_RAW_SPINLOCK(irq_big_lock);
>  static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
>  static unsigned int irq_radix_writer;
>  struct irq_map_entry irq_map[NR_IRQS];

    I've already sent a patch fixing this one (along with many others) a month 
ago:

http://ozlabs.org/pipermail/linuxppc-dev/2007-February/031164.html

    I wonder iof it was ever considered... :-/

WBR, Sergei
