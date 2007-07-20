Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbXGTMbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbXGTMbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbXGTMat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:30:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39426 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755719AbXGTMas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:30:48 -0400
Date: Fri, 20 Jul 2007 14:30:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm/Kconfig MEMORY_HOTPLUG typo ?
Message-ID: <20070720123011.GY3801@stusta.de>
References: <46A0A954.4020102@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46A0A954.4020102@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 02:23:48PM +0200, Gabriel C wrote:
> Hi,
> 
> I'm a bit confused about the following from mm/Kconfig:
> 
> ..
> 
> config MEMORY_HOTPLUG
>         bool "Allow for memory hot-add"
>         depends on SPARSEMEM || X86_64_ACPI_NUMA
>         depends on HOTPLUG && !SOFTWARE_SUSPEND && ARCH_ENABLE_MEMORY_HOTPLUG
>         depends on (IA64 || X86 || PPC64 || SUPERH)
> 
> comment "Memory hotplug is currently incompatible with Software Suspend"
>         depends on SPARSEMEM && HOTPLUG && SOFTWARE_SUSPEND
> 
> 
> ...
> 
> That should be !SOFTWARE_SUSPEND no ?

No, it's correct.

You should see the comment instead of the option with SOFTWARE_SUSPEND=y.

> Regards,
> 
> Gabriel C

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

