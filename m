Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbXGITpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbXGITpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXGITpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:45:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55924 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754334AbXGITpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:45:10 -0400
Date: Mon, 9 Jul 2007 21:45:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22: section mismatch warnings
Message-ID: <20070709194540.GJ3492@stusta.de>
References: <20070709184200.GA2496@janus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070709184200.GA2496@janus>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 08:42:01PM +0200, Frank van Maarseveen wrote:
> WARNING: arch/i386/kernel/built-in.o(.text+0xf5c1): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.text+0xf5c7): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.text+0xf5da): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.exit.text+0x1c): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
> WARNING: arch/i386/kernel/built-in.o(.data+0xe80): Section mismatch: reference to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
> WARNING: kernel/built-in.o(.text+0x1add5): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')

I think I see the problem, but please send your .config so that I can 
verify it.

> Frank

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

