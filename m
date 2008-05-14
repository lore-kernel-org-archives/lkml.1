Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYENM4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYENM4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbYENM4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:56:12 -0400
Received: from [198.99.130.12] ([198.99.130.12]:44709 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbYENM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:56:12 -0400
Date: Wed, 14 May 2008 08:55:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: toralf.foerster@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: UML build issue with v2.6.26-rc2-129-g9604006
Message-ID: <20080514125548.GA6373@c2.user-mode-linux.org>
References: <200805141301.30027.toralf.foerster@gmx.de> <20080514112217.GC2520@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514112217.GC2520@hacking>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 07:22:17PM +0800, WANG Cong wrote:
> On Wed, May 14, 2008 at 01:01:27PM +0200, =?ISO-8859-1?Q?Toralf_F=F6rster_ wrote:
> >Today I got:
> >
> >...
> >  CC      arch/um/os-Linux/skas/process.o
> >  LD      arch/um/os-Linux/skas/built-in.o
> >  CC      arch/um/os-Linux/sys-i386/registers.o
> >arch/um/os-Linux/sys-i386/registers.c:8:22: error: asm/user.h: No such file or directory
> >arch/um/os-Linux/sys-i386/registers.c: In function 'arch_init_registers':
> >arch/um/os-Linux/sys-i386/registers.c:78: error: storage size of 'fpx_regs' isn't known
> >arch/um/os-Linux/sys-i386/registers.c:78: warning: unused variable 'fpx_regs'
> >make[2]: *** [arch/um/os-Linux/sys-i386/registers.o] Error 1
> >make[1]: *** [arch/um/os-Linux/sys-i386] Error 2
> >make: *** [arch/um/os-Linux] Error 2
> 
> 
> Hmm, it seems that I can't reproduce it with your .config.
> And <asm/user.h> does exist.

I bet he's using the headers exported by the current kernel, not what
his distro gives him.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
