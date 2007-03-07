Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXCGOy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXCGOy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXCGOy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:54:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:19915 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965549AbXCGOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:54:56 -0500
Message-ID: <45EED235.9010509@ru.mvista.com>
Date: Wed, 07 Mar 2007 17:54:45 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/6 -rt] powerpc 2.6.20-rt8: to convert spinlocks to	raw
 ones.
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi649d25qz.wl@toshiba.co.jp>	 <45EECE5C.6030100@ru.mvista.com> <1173278589.8635.4.camel@localhost.localdomain>
In-Reply-To: <1173278589.8635.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Benjamin Herrenschmidt wrote:

>>>--- linux-rt8/arch/powerpc/kernel/irq.c	2007-02-20 14:30:38.000000000 +0900
>>>+++ rt/arch/powerpc/kernel/irq.c	2007-03-05 18:54:34.000000000 +0900
>>>@@ -392,7 +392,7 @@ EXPORT_SYMBOL(do_softirq);
>>> #ifdef CONFIG_PPC_MERGE
>>> 
>>> static LIST_HEAD(irq_hosts);
>>>-static spinlock_t irq_big_lock = SPIN_LOCK_UNLOCKED;
>>>+static DEFINE_RAW_SPINLOCK(irq_big_lock);
>>> static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
>>> static unsigned int irq_radix_writer;
>>> struct irq_map_entry irq_map[NR_IRQS];

>>    I've already sent a patch fixing this one (along with many others) a month 
>>ago:

>>http://ozlabs.org/pipermail/linuxppc-dev/2007-February/031164.html

>>    I wonder iof it was ever considered... :-/

> It was but not for 2.6.21 timeframe due to people lack of time/bandwidth
> among others :-)

    I was asking Ingo, basically. :-)

> I intend to try to spend some time before the 2.6.22 merge window to
> gather those -rt related patches that can be merged already and push
> them to powerpc.git.

> (Note to mingo: that means that we might end up with patches both in
> your tree and being push via powerpc, I hope that's not too much of a
> problem).

    Well, this is happening every -rc1 now -- part of -rt getting merged to 
mainline.

> I can't promise I'll have time to do much, but I'd like to do it, so
> find me on irc every now and then to "poke" if you don't see anything
> happening...

    My purpose was only to get this into -rt patch for now.

> Cheers,
> Ben.

WBR, Sergei
