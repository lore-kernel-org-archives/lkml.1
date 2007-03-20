Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbXCTMNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbXCTMNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXCTMNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:13:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40415 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbXCTMNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:13:51 -0400
Date: Tue, 20 Mar 2007 13:14:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2
Message-ID: <20070320121432.GC10240@uranus.ravnborg.org>
References: <20070307201915.4d579113.akpm@linux-foundation.org> <20070319172711.1176b3d4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319172711.1176b3d4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 05:27:11PM -0700, Randy Dunlap wrote:
> On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
> > 
> > - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
> >   were dropped.
> > 
> >   This is for A/B comparison purposes, and because those changes crashed on
> >   one test setup.
> 
> I don't quite see why this error is happening.  Looks like all
> the nested #includes should handle it...
> 
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_UTRACE=y
> # PTRACE=n
> # PROC_FS=n
> 
> In file included from arch/x86_64/kernel/crash.c:19:
> include/linux/elfcore.h: In function 'elf_core_copy_regs':
> include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
> include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
> make[1]: *** [arch/x86_64/kernel/crash.o] Error 1
> make: *** [arch/x86_64/kernel] Error 2

make arch/x86_64/kernel/crash.i
may tell you a bit more why the includes foes wrong.

	Sam
