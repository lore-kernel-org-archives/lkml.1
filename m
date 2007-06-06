Return-Path: <linux-kernel-owner+w=401wt.eu-S1763608AbXFFLMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763608AbXFFLMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbXFFLMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:12:15 -0400
Received: from baikonur.stro.at ([213.239.196.228]:3542 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761149AbXFFLMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:12:12 -0400
Date: Wed, 6 Jun 2007 13:11:41 +0200
From: maximilian attems <max@stro.at>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: Re: [patch] Kconfig.debug DEBUG_PREEMPT dependency
Message-ID: <20070606111141.GE32083@stro.at>
References: <20070606105314.GD32083@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606105314.GD32083@stro.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007, maximilian attems wrote:

> -	depends on DEBUG_KERNEL && PREEMPT && TRACE_IRQFLAGS_SUPPORT
> +	depends on DEBUG_KERNEL && (PREEMPT || PREEMPT_BKL) && TRACE_IRQFLAGS_SUPPORT

upps please discard needs more work:
arch/i386/kernel/built-in.o: In function `show_registers':
(.text+0x2e8e): undefined reference to `add_preempt_count'
arch/i386/kernel/built-in.o: In function `show_registers':
(.text+0x2e9c): undefined reference to `sub_preempt_count'
arch/i386/kernel/built-in.o: In function `show_registers':
(.text+0x2ef2): undefined reference to `add_preempt_count'
arch/i386/kernel/built-in.o: In function `show_registers':
(.text+0x2f02): undefined reference to `sub_preempt_count'
arch/i386/kernel/built-in.o: In function `is_valid_bugaddr':
(.text+0x366c): undefined reference to `add_preempt_count'
arch/i386/kernel/built-in.o: In function `is_valid_bugaddr':
(.text+0x367b): undefined reference to `sub_preempt_count'
arch/i386/kernel/built-in.o: In function `romchecksum':
...

-- 
maks
