Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYBRNbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYBRNbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYBRNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:31:36 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51677 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYBRNbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:31:35 -0500
Date: Mon, 18 Feb 2008 15:31:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>, Russell Leidich <rml@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc2-mm1 (x86 MCE build error)
Message-ID: <20080218133104.GC21080@cs181133002.pp.htv.fi>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080217211755.8c2367cc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080217211755.8c2367cc.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 09:17:55PM -0800, Randy Dunlap wrote:
> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> It's possible to config a specific CPU and also enable Intel MCE checks
> and AMD MCE checks, ending with this:
> 
> arch/x86/kernel/built-in.o: In function `smp_thermal_interrupt_init':
> mce_amd_64.c:(.text+0xd7ea): undefined reference to `num_k8_northbridges'
> mce_amd_64.c:(.text+0xd800): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd863): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd888): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd8b1): undefined reference to `num_k8_northbridges'
> mce_amd_64.c:(.text+0xd8d8): undefined reference to `num_k8_northbridges'
> mce_amd_64.c:(.text+0xd8f3): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd917): undefined reference to `num_k8_northbridges'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> .config file is attached.

That's x86-amd-thermal-interrupt-support.patch failing with 
CONFIG_K8_NB=n.

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

