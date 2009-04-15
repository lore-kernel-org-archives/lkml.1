Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZDOOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZDOOS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZDOOSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:18:17 -0400
Received: from web65503.mail.ac4.yahoo.com ([76.13.9.47]:31836 "HELO
	web65503.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752965AbZDOOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:18:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=uThcUmwf9YKAkLG00HR+UwLAe2o4TvYD4fggTMP4dTEwX+ZI1n+uYZonvhL4GFj7sm7VFCD09fb6BnTdojyVgpEjvODrZpt3liP0VMDb2YFisu87rC7E6oQ5Rh3H0wCRKokXviG+rQx5sdy3ISnS4V6lSpcmjao0Qpc8cyhmgU8=;
Message-ID: <344183.64836.qm@web65503.mail.ac4.yahoo.com>
X-YMail-OSG: S9QnpwcVM1kdaQXhwJt3IQv4CpQWbD22oVE_rDRAzzkaA5.wlX..EVa_cnlVwZsfy8mZK6nJzv2Nc9MVNSFnzpmWw1PVmpWReEqKXW7bTYhj5DaqHSeJo78T4yVHU_EVEsRHR5UHE06ndUrOITg42noexLYbe4DB7FV.YAgRDplWlEiGtqtbXnV6cB374XMimb2Bof5xf7ZGRGTIdp5GYJ7npwjMIDoeohQNNjyYemw_DO2TtRjIuy8gFz_Fx.3Sw2DT13H3QHbra12bbFCCBViZ
X-Mailer: YahooMailWebService/0.7.289.1
Date: Wed, 15 Apr 2009 07:18:13 -0700 (PDT)
From: Jerry Wang <jerry18th@yahoo.com>
Reply-To: jerry18th@yahoo.com
Subject: Linux Kernel Cross-Compiling question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am trying to cross-compile the linux 2.6.11.1 kernel on
i686 vm for ppc, and I've been getting the following
errors. Has anyone had this issue before?

Thanks,
Jerry 

> In file included from arch/ppc/kernel/asm-offsets.c:13:
> include/linux/sched.h: In function
> `arch_pick_mmap_layout':
> include/linux/sched.h:1174: error: `CONFIG_TASK_SIZE'
> undeclared (first use in this function)
> include/linux/sched.h:1174: error: (Each undeclared
> identifier is reported only once
> include/linux/sched.h:1174: error: for each function it
> appears in.)
> In file included from include/linux/mman.h:5,
>                  from arch/ppc/kernel/asm-offsets.c:19:
> include/linux/mm.h: In function `lowmem_page_address':
> include/linux/mm.h:437: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> In file included from arch/ppc/kernel/asm-offsets.c:21:
> include/asm/io.h: In function `virt_to_bus':
> include/asm/io.h:396: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> include/asm/io.h: In function `bus_to_virt':
> include/asm/io.h:407: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> include/asm/io.h: In function `virt_to_phys':
> include/asm/io.h:420: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> include/asm/io.h: In function `phys_to_virt':
> include/asm/io.h:429: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> arch/ppc/kernel/asm-offsets.c: In function `main':
> arch/ppc/kernel/asm-offsets.c:139: error:
> `CONFIG_TASK_SIZE' undeclared (first use in this
> function)
> make[1]: *** [arch/ppc/kernel/asm-offsets.s] Error 1
> make: *** [arch/ppc/kernel/asm-offsets.s] Error 2


      
