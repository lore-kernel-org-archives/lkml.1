Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYJCDcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYJCDcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYJCDce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:32:34 -0400
Received: from xenotime.net ([66.160.160.81]:34814 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754141AbYJCDce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:32:34 -0400
Date: Thu, 2 Oct 2008 20:32:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
Message-Id: <20081002203230.27b92b30.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.64.0810021705460.26309@shark.he.net>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810021705460.26309@shark.he.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 17:17:16 -0700 (PDT) Randy.Dunlap wrote:

> On Thu, 2 Oct 2008, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-10-02-16-17 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27-rc8:
> 
> 10 out of 10 build randconfig failures on i386;
> 10 out of 10 build randconfig failures on x86_64.
> 
> Summary for i386:
> 
> build-r9491.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/fs/autofs4/dev-ioctl.c:310: error: too 
> many arguments to function 'dentry_open'
> 
> ~~~ (with copy-and-paste line breaks)
> 
> build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_32.c:1539: warn
> ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_32.c:1540: warn
> ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'

Weren't these already fixed once?  Could they be in one of the 180-or-so
-tip branches but you don't have it?

> 
> Summary for x86_64:
> 
> (lots of these)
> build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_64.c:1284: warn
> ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_64.c:1285: warn
> ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'

Same question for these...

> build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/fs/autofs4/dev-ioctl.c:310: error: too 
> many arguments to function 'dentry_open'

You (akpm) made a patch (autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch)
which adds arg4 to this call to dentry_open() but I can't find why/where a 4th arg
was added and the patch doesn't seem to be needed here/now.  what gives?


---
~Randy
