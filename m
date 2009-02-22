Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZBVW6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZBVW6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZBVW6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:58:38 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:35902 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZBVW6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:58:38 -0500
Date: Mon, 23 Feb 2009 00:00:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel building procedure changed?
Message-ID: <20090222230031.GB30619@uranus.ravnborg.org>
References: <20090222220747.GB7279@localhost> <20090222221653.GA30498@uranus.ravnborg.org> <49A1D167.8050801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A1D167.8050801@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 11:27:51PM +0100, Jiri Slaby wrote:
> On 22.2.2009 23:16, Sam Ravnborg wrote:
> >On Mon, Feb 23, 2009 at 01:07:48AM +0300, Cyrill Gorcunov wrote:
> >>Hi all,
> >>
> >>I found a bit strange thing happens now --
> >>plain
> >>
> >>	make arch/x86/kernel/head64.o
> >>
> >>doesn't work anymore. Instead of compiling
> >>_just_ this file I've got the following:
> >>
> >>---
> >>cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head64.o
> >>   CHK     include/linux/version.h
> >>   CHK     include/linux/utsrelease.h
> >>   SYMLINK include/asm ->  include/asm-x86
> >>   CALL    scripts/checksyscalls.sh
> >>   CHK     include/linux/compile.h
> >>   AS      arch/x86/kernel/head_64.o
> >>   VDSOSYM arch/x86/vdso/vdso-syms.lds
> >>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
> >>   VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
> >>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
> >>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
> >>   LD      arch/x86/vdso/built-in.o
> >>   CC      fs/hpfs/dnode.o
> >>make[2]: *** [fs/hpfs/dnode.o] Interrupt
> >>make[1]: *** [fs/hpfs] Interrupt
> >>make: *** [fs] Interrupt
> >>---
> >>
> >>I've done make allyesconfig previously.
> >>I don't understand what I'm doing wrong... :(
> >
> >I should work...
> 
> It is matter of days, new mmotm doesn't work either, older did.

Does it happen with -next?
Does it happen with mainline?
I need to know what tree to look at - and I do not have mmotm handy.

	Sam
