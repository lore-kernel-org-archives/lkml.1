Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYGOUtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYGOUtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759199AbYGOUt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:49:26 -0400
Received: from gw.goop.org ([64.81.55.164]:47357 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbYGOUtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:49:24 -0400
Message-ID: <487D0D43.2000003@goop.org>
Date: Tue, 15 Jul 2008 13:49:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sebastian Siewior <bigeasy@linutronix.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] mm: fix build on non-mmu machines
References: <20080715202846.GA8867@www.tglx.de>
In-Reply-To: <20080715202846.GA8867@www.tglx.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Siewior wrote:
> Commit 1ea0704e0d aka
>  [mm: add a ptep_modify_prot transaction abstraction]
>
> caused:
>
> |  CC      init/main.o
> |In file included from include2/asm/pgtable.h:68,
> |                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/mm.h:39,
> |                 from include2/asm/uaccess.h:8,
> |                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/poll.h:13,
> |                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/rtc.h:113,
> |                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/efi.h:19,
> |                 from /home/bigeasy/git/linux-2.6-m68k/init/main.c:43:
> |/linux-2.6/include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
> |/linux-2.6/include/asm-generic/pgtable.h:209: error: implicit declaration of function 'ptep_get_and_clear'
> |/linux-2.6/include/asm-generic/pgtable.h:209: error: incompatible types in return
> |/linux-2.6/include/asm-generic/pgtable.h: In function '__ptep_modify_prot_commit':
> |/linux-2.6/include/asm-generic/pgtable.h:220: error: implicit declaration of function 'set_pte_at'
> |make[2]: *** [init/main.o] Error 1
> |make[1]: *** [init] Error 2
> |make: *** [sub-make] Error 2
>
> on my m68knommu box.
> Now I'm, not sure If this is the right solution, but with this
> patch applied I am able to boot the kernel I've build.
>   

I just posted an identical patch, so I'll take that as confirmation that 
it works ;)

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
