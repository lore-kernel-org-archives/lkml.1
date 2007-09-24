Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbXIXXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbXIXXLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbXIXXLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:11:09 -0400
Received: from xenotime.net ([66.160.160.81]:38216 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753095AbXIXXLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:11:08 -0400
Date: Mon, 24 Sep 2007 16:11:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Laurent Riffard <laurent.riffard@free.fr>, kexec@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1: build error with CONFIG_KEXEC=y and
 CONFIG_NOHIGHMEM=y
Message-Id: <20070924161103.17d7349a.rdunlap@xenotime.net>
In-Reply-To: <46F819BC.3010802@free.fr>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	<46F819BC.3010802@free.fr>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[adding kexec m-l]

On Mon, 24 Sep 2007 22:10:36 +0200 Laurent Riffard wrote:

> Le 24.09.2007 11:17, Andrew Morton a écrit :
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> > 
> 
> I've got this compilation when CONFIG_KEXEC=y and CCONFIG_NOHIGHMEM=y:
> 
> linux-2.6-mm$ LANG=C make 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      arch/i386/kernel/setup.o
> arch/i386/kernel/setup.c: In function 'reserve_crashkernel':
> arch/i386/kernel/setup.c:391: error: 'highend_pfn' undeclared (first use in this function)
> arch/i386/kernel/setup.c:391: error: (Each undeclared identifier is reported only once
> arch/i386/kernel/setup.c:391: error: for each function it appears in.)
> arch/i386/kernel/setup.c:391: error: 'highstart_pfn' undeclared (first use in this function)
> make[1]: *** [arch/i386/kernel/setup.o] Error 1
> make: *** [arch/i386/kernel] Error 2
> 
> 
> .config attached.
> ~~
> laurent
> 


---
~Randy
Phaedrus says that Quality is about caring.
