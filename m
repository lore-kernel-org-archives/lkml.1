Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYARILX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYARILX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYARILQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:11:16 -0500
Received: from free-electrons.com ([88.191.23.47]:40864 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYARILP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:11:15 -0500
Message-ID: <47905F0C.1090708@free-electrons.com>
Date: Fri, 18 Jan 2008 09:10:52 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: clean arch/[i386|x86_64] in make mrproper
References: <200801171437.25038.michael-lists@free-electrons.com>
In-Reply-To: <200801171437.25038.michael-lists@free-electrons.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2008 02:37 PM, Michael Opdenacker wrote:
>
> Proposed fix: add arch/i386 and arch/x86_84 to the list of
> directories cleaned by "make mrproper"
>
> Cleaner solution: stop creating these symbolic links, but this
> could cause issues with scripts still expecting bzImage in
> arch/i386/boot/bzImage or in arch/x86_64/boot/bzImage.
>
> What do you think? I can submit another patch for the second
> option.
>
> Michael.
>
> Signed-off-by: Michael Opdenacker <michael@free-electrons.com> ---
> linux-2.6.24-rc8-git1/Makefile    2008-01-17 09:54:22.000000000
> +0100 +++ linux-2.6.24-rc8-git1-mrproper-x86/Makefile    2008-01-17
> 10:49:19.000000000 +0100 @@ -1088,7 +1088,7 @@ .tmp_kallsyms*
> .tmp_version .tmp_vmlinux* .tmp_System.map
>
> # Directories & files removed with 'make mrproper' -MRPROPER_DIRS
> += include/config include2 usr/include +MRPROPER_DIRS  +=
> include/config include2 usr/include arch/i386 arch/x86_64
> MRPROPER_FILES += .config .config.old include/asm .version
> .old_version \ include/linux/autoconf.h include/linux/version.h
> \ include/linux/utsrelease.h                            \
>
The problem is still there in 2.6.24-rc8-git2. In my opinion, it's a
significant bug in the kernel build system that "make mrproper" and
"make distclean" don't remove all generated files. 2.6.24 shoudn't
ship with this bug.

What do you think?

Cheers,

Michael.


-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

