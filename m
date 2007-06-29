Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXF2Us7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXF2Us7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbXF2Usv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:48:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001AbXF2Usv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:48:51 -0400
Date: Fri, 29 Jun 2007 13:47:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Jason Wessel <jason.wessel@windriver.com>,
       Michal Marek <mmarek@suse.cz>
Cc: paulus@samba.org, xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, xfs@oss.sgi.com
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070629134748.71adba1e.akpm@linux-foundation.org>
In-Reply-To: <200706291432.10128.m.kozlowski@tuxland.pl>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<200706291432.10128.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 14:32:09 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	allmodconfig on powerpc (iMac g3) fails due to
> git-kgdb.patch. allmodconfig defaults should be changed?
> 
>   CC      arch/powerpc/kernel/kgdb.o
> arch/powerpc/kernel/kgdb.c:485:2: error: #error Both XMON and KGDB selected 
> in .config. Unselect one of them.
> make[1]: *** [arch/powerpc/kernel/kgdb.o] Blad 1
> make: *** [arch/powerpc/kernel] Blad 2

Jason cc'ed

> anyway after unselecting XMON we can see:
> 
>   CC [M]  fs/xfs/linux-2.6/xfs_ioctl32.o
> fs/xfs/linux-2.6/xfs_ioctl32.c: In function 'xfs_ioc_bulkstat_compat':
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: 'xfs_inumbers_fmt_compat' 
> undeclared (first use in this function)
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared identifier is 
> reported only once
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appears in.)
> make[2]: *** [fs/xfs/linux-2.6/xfs_ioctl32.o] Blad 1
> make[1]: *** [fs/xfs] Blad 2
> 
> This is just allmodconfig - not a .config that's used daily by users but I'm 
> used to compiling the kernel using it anyway 8)
> 

Michal cc'ed.  I think this is the one which was already reported but
I haven't seen a fix yet?
