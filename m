Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYJCDiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYJCDiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYJCDiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:38:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbYJCDiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:38:03 -0400
Date: Thu, 2 Oct 2008 20:37:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
Message-Id: <20081002203759.55f49dad.akpm@linux-foundation.org>
In-Reply-To: <20081002203230.27b92b30.rdunlap@xenotime.net>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810021705460.26309@shark.he.net>
	<20081002203230.27b92b30.rdunlap@xenotime.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 20:32:30 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Thu, 2 Oct 2008 17:17:16 -0700 (PDT) Randy.Dunlap wrote:
> 
> > On Thu, 2 Oct 2008, akpm@linux-foundation.org wrote:
> > 
> > > The mm-of-the-moment snapshot 2008-10-02-16-17 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > It contains the following patches against 2.6.27-rc8:
> > 
> > 10 out of 10 build randconfig failures on i386;
> > 10 out of 10 build randconfig failures on x86_64.
> > 
> > Summary for i386:
> > 
> > build-r9491.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/fs/autofs4/dev-ioctl.c:310: error: too 
> > many arguments to function 'dentry_open'
> > 
> > ~~~ (with copy-and-paste line breaks)
> > 
> > build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_32.c:1539: warn
> > ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> > build-r9502.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_32.c:1540: warn
> > ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> 
> Weren't these already fixed once?  Could they be in one of the 180-or-so
> -tip branches but you don't have it?

That's a workable theory.

> > 
> > Summary for x86_64:
> > 
> > (lots of these)
> > build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_64.c:1284: warn
> > ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> > build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/arch/x86/kernel/io_apic_64.c:1285: warn
> > ing: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> 
> Same question for these...
> 
> > build-r9493.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/fs/autofs4/dev-ioctl.c:310: error: too 
> > many arguments to function 'dentry_open'
> 
> You (akpm) made a patch (autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch)
> which adds arg4 to this call to dentry_open() but I can't find why/where a 4th arg
> was added and the patch doesn't seem to be needed here/now.  what gives?
> 

Some other tree which fell out of the pile changed the dentry_open()
interface so that fix isn't needed until it is needed again.

Really, it's not worth bothering about at present.  I wonder what's on TV?
