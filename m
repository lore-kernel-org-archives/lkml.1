Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZGFAUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZGFAUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 20:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbZGFAUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 20:20:45 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33050 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbZGFAUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 20:20:45 -0400
Message-ID: <4A514177.4000505@necel.com>
Date: Mon, 06 Jul 2009 09:12:39 +0900
From: Shinya Kuribayashi <shinya.kuribayashi@necel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       skuribay@ruby.dti.ne.jp, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Trivial: Fix filenames in their headers for the	EMMA
 Mark-eins.
References: <1246746621-10320-1-git-send-email-cascardo@holoscopio.com> <20090705223051.GA18858@linux-mips.org>
In-Reply-To: <20090705223051.GA18858@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> Different suggestion - let's remove these comment lines entirely.  I just
> don't see any use for them.  So this patch removes them along with a few
> very obvious comments.

I like this one.

>  arch/mips/dec/ecc-berr.c                          |    2 --
>  arch/mips/dec/int-handler.S                       |    2 --
>  arch/mips/dec/ioasic-irq.c                        |    2 --
>  arch/mips/dec/kn01-berr.c                         |    2 --
>  arch/mips/dec/kn02-irq.c                          |    2 --
>  arch/mips/dec/kn02xa-berr.c                       |    2 --
>  arch/mips/dec/prom/call_o32.S                     |    2 --
>  arch/mips/dec/prom/console.c                      |    2 --
>  arch/mips/dec/time.c                              |    2 --
>  arch/mips/emma/common/Makefile                    |    3 ---
>  arch/mips/emma/common/prom.c                      |    3 ---
>  arch/mips/emma/markeins/Makefile                  |    3 ---
>  arch/mips/emma/markeins/irq.c                     |    3 ---
>  arch/mips/emma/markeins/led.c                     |    3 ---
>  arch/mips/emma/markeins/platform.c                |    3 ---
>  arch/mips/emma/markeins/setup.c                   |    3 ---

How about arch/mips/fw/lib/call_o32.S?

>  arch/mips/include/asm/emma/emma2rh.h              |    3 ---
>  arch/mips/include/asm/emma/markeins.h             |    3 ---
>  arch/mips/kernel/irq_txx9.c                       |    2 --
>  arch/mips/kernel/proc.c                           |    2 --
>  arch/mips/kernel/stacktrace.c                     |    2 --
>  arch/mips/mm/extable.c                            |    3 ---
>  arch/mips/pci/fixup-emma2rh.c                     |    3 ---
>  arch/mips/pci/fixup-sb1250.c                      |    2 --
>  arch/mips/pci/ops-emma2rh.c                       |    3 ---
>  arch/mips/pci/pci-emma2rh.c                       |    3 ---
>  arch/mips/pci/pci-tx4927.c                        |    2 --
>  arch/mips/pci/pci-tx4938.c                        |    2 --
>  arch/mips/pci/pci-tx4939.c                        |    2 --
>  arch/mips/pmc-sierra/msp71xx/gpio.c               |    2 --
>  arch/mips/pmc-sierra/msp71xx/gpio_extended.c      |    2 --
>  arch/mips/pmc-sierra/yosemite/atmel_read_eeprom.c |    2 --
>  arch/mips/sibyte/swarm/swarm-i2c.c                |    2 --
>  arch/mips/txx9/generic/mem_tx4927.c               |    2 --
>  arch/mips/txx9/generic/setup.c                    |    2 --
>  35 files changed, 0 insertions(+), 83 deletions(-)

[...]

> diff --git a/arch/mips/mm/extable.c b/arch/mips/mm/extable.c
> index 297fb9f..e94ea59 100644
> --- a/arch/mips/mm/extable.c
> +++ b/arch/mips/mm/extable.c
> @@ -1,6 +1,3 @@
> -/*
> - * linux/arch/mips/mm/extable.c
> - */
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
>  #include <asm/branch.h>

Btw, let's have extable.c have, at least, a copyright later.

Acked-by: Shinya Kuribayashi <shinya.kuribayashi@necel.com>

-- 
Shinya Kuribayashi
NEC Electronics
