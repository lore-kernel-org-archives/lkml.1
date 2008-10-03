Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYJCAR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYJCAR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYJCART
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:17:19 -0400
Received: from xenotime.net ([66.160.160.81]:59046 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753484AbYJCARS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:17:18 -0400
Date: Thu, 2 Oct 2008 17:17:16 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
In-Reply-To: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810021705460.26309@shark.he.net>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-10-02-16-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27-rc8:

10 out of 10 build randconfig failures on i386;
10 out of 10 build randconfig failures on x86_64.

Summary for i386:

build-r9491.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/include/linux/stacktrace.h:13: warning:
 'struct task_struct' declared inside parameter list
build-r9491.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/include/linux/stacktrace.h:13: warning:
 its scope is only this definition or declaration, which is probably not what you want
build-r9491.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/fs/autofs4/dev-ioctl.c:310: error: too 
many arguments to function 'dentry_open'

~~~ Lots of these:

build-r9494.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/process_32.c:87: error:
 implicit declaration of function 'cpu_uninit'
build-r9494.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/process_32.c:99: error:
 redefinition of 'play_dead'
build-r9494.out:include2/asm/smp.h:112: error: previous definition of 'play_dead' was here

~~~ (with copy-and-paste line breaks)

build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_32.c:1539: warn
ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_32.c:1540: warn
ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/include/linux/stacktrace.h:13: warning:
 'struct task_struct' declared inside parameter list
build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/include/linux/stacktrace.h:13: warning:
 its scope is only this definition or declaration, which is probably not what you want
build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/drivers/char/stallion.c:615: error: imp
licit declaration of function 'tty_port_tty_get'
build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/drivers/char/stallion.c:739: error: imp
licit declaration of function 'tty_port_tty_set'


Summary for x86_64:

(several of these)
build-r9492.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/process_64.c:95: error:
 redefinition of 'play_dead'
build-r9492.out:include2/asm/smp.h:112: error: previous definition of 'play_dead' was here

~~~

(lots of these)
build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_64.c:1284: warn
ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_64.c:1285: warn
ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/k8.c:20: error: 'PCI_DE
VICE_ID_AMD_10H_NB_MISC' undeclared here (not in a function)
build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/fs/autofs4/dev-ioctl.c:310: error: too 
many arguments to function 'dentry_open'

~~~

I'll work on some patches for them as time permits...
or you could drop them, push them back to their submitters...

-- 
~Randy
