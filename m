Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYEDPMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYEDPMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYEDPMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:12:38 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64774 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYEDPMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:12:37 -0400
Message-Id: <481DD247.70807@ct.jp.nec.com>
Date: Sun, 04 May 2008 08:12:07 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_32: move do_nmi() to nmi_32.c
References: <481BA78F.50202@ct.jp.nec.com> <20080504094058.GA17566@elte.hu>
In-Reply-To: <20080504094058.GA17566@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> on x86_64 do_nmi() is in nmi_64.c.
> 
> this patch caused build failure on x86.git+sched-devel.git:
> 
> arch/x86/kernel/built-in.o: In function `nmi_stack_correct':
> arch/x86/kernel/entry_32.S:(.kprobes.text+0x117): undefined reference to `do_nmi'
> arch/x86/kernel/built-in.o: In function `nmi_espfix_stack':
> arch/x86/kernel/entry_32.S:(.kprobes.text+0x1c3): undefined reference to `do_nmi'
> arch/x86/kernel/built-in.o: In function `alternative_instructions':
> : undefined reference to `stop_nmi'
> arch/x86/kernel/built-in.o: In function `alternative_instructions':
> : undefined reference to `restart_nmi'
> 
> with this config:
> 
>  http://redhat.com/~mingo/misc/config-Sun_May__4_11_25_21_CEST_2008.bad

Oops, I've missed something.

Will work. If you don't want it soon, please remove it from the queue.

thanks,
Hiroshi Shimamoto
