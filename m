Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYEDLBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYEDLBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 07:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYEDLB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 07:01:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42344 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYEDLB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 07:01:26 -0400
Date: Sun, 4 May 2008 13:02:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #479 for v2.6.26-rc1-6-gafa26be :redefinition of 'sysfs_update_group'
Message-ID: <20080504110201.GE17276@uranus.ravnborg.org>
References: <200805041053.43284.toralf.foerster@gmx.de> <20080504104127.GD17276@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080504104127.GD17276@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 12:41:27PM +0200, Sam Ravnborg wrote:
> On Sun, May 04, 2008 at 10:53:40AM +0200, Toralf Förster wrote:
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> > scripts/kconfig/conf -s arch/x86/Kconfig
> >   CHK     include/linux/version.h
> >   UPD     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   UPD     include/linux/utsrelease.h
> >   SYMLINK include/asm -> include/asm-x86
> >   CC      kernel/bounds.s
> >   GEN     include/linux/bounds.h
> >   CC      arch/x86/kernel/asm-offsets.s
> > In file included from include/linux/kobject.h:21,
> >                  from include/linux/module.h:16,
> >                  from include/linux/crypto.h:21,
> >                  from arch/x86/kernel/asm-offsets_32.c:7,
> >                  from arch/x86/kernel/asm-offsets.c:2:
> > include/linux/sysfs.h:201: error: redefinition of 'sysfs_update_group'
> > include/linux/sysfs.h:195: error: previous definition of 'sysfs_update_group' was here
> > make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> > make: *** [prepare0] Error 2
> > 
> > The build was made with :
> > $> make mrproper && make randconfig && make
> 
> Why do you need the "make mrproper" in the first place?

Hi Toralf.
Just to make it clear...

If you know of some kbuild shortcomings I would like to know
of them so I can either fix it or document it.

	Sam
