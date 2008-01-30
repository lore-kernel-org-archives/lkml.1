Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYA3SZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYA3SZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYA3SZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:25:05 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59299 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYA3SZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:25:03 -0500
Date: Wed, 30 Jan 2008 20:25:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: arch/x86/kernel/test_nx.c compile error
Message-ID: <20080130182537.GD29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<--  snip  -->

...
  CC [M]  arch/x86/kernel/test_nx.o
{standard input}: Assembler messages:
{standard input}:58: Error: cannot represent relocation type BFD_RELOC_64
{standard input}:59: Error: cannot represent relocation type BFD_RELOC_64
make[2]: *** [arch/x86/kernel/test_nx.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [sub-make] Error 2
$ gcc --version
gcc (GCC) 4.2.3 20080114 (prerelease) (Debian 4.2.2-7)
...
$ as --version
GNU assembler (GNU Binutils for Debian) 2.18.0.20080103
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

