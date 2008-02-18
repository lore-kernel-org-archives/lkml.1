Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbYBRWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbYBRWOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbYBRWO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:14:26 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:44780 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbYBRWOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:14:25 -0500
Date: Mon, 18 Feb 2008 23:14:04 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Sergio Luis <sergio@larces.uece.br>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8):
 undefined reference to `LGUEST_PAGES_regs_trapnum'
In-Reply-To: <47B8DFD8.6040602@larces.uece.br>
Message-ID: <alpine.DEB.1.00.0802182305590.6469@sheep.housecafe.de>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <alpine.LFD.1.00.0802171451060.7583@apollo.tec.linutronix.de> <47B83F90.7000203@larces.uece.br> <alpine.DEB.1.00.0802172109590.6469@sheep.housecafe.de>
 <47B8D99A.3020202@larces.uece.br> <47B8DFD8.6040602@larces.uece.br>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Sergio Luis wrote:
> oops. sorry, I just realized I missed the makefile part. I changed
> the config symbol to CONFIG_LGUEST_HYPERVISOR so I should change it on 
> the makefile as well. reposting an updated patch for testing:

Hm, now I cannot select LGUEST as a module any more:

$ make clean && time make
   [...]
   HOSTCC  scripts/kconfig/zconf.tab.o
   HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86/Kconfig
.config:1793:warning: symbol value 'm' invalid for LGUEST
   [...]
   Linux hypervisor (LGUEST) [Y/n/?] (NEW)

Is this intentional? I've tried your patch with or without Rusty's patch, 
both gave me the same results. My .config:
http://nerdbynature.de/bits/2.6.25-rc2/lguest/

Thanks,
Christian.
-- 
BOFH excuse #400:

We are Microsoft.  What you are experiencing is not a problem; it is an undocumented feature.
