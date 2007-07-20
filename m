Return-Path: <linux-kernel-owner+w=401wt.eu-S938176AbXGTBeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938176AbXGTBeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbXGTBdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:33:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759851AbXGTBdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:33:53 -0400
Date: Thu, 19 Jul 2007 18:33:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][resend] Remove spec doc links in hpet header files
Message-Id: <20070719183314.2d7d2331.akpm@linux-foundation.org>
In-Reply-To: <20070720084510.GA1779@darkstar.te-china.tietoenator.com>
References: <20070720084510.GA1779@darkstar.te-china.tietoenator.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 08:45:10 +0000
Dave Young <hidave.darkstar@gmail.com> wrote:

> Hi,
> The links are broken, and already exist in Documentation/hpet.txt, so
> remove them for header files.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ---
> include/asm-i386/hpet.h   |    6 ------
> include/asm-x86_64/hpet.h |    6 ------
> 2 files changed, 12 deletions(-)
> 
> diff -pur linux/include/asm-i386/hpet.h linux.new/include/asm-i386/hpet.h
> --- linux/include/asm-i386/hpet.h	2007-07-11 11:15:42.000000000 +0000
> +++ linux.new/include/asm-i386/hpet.h	2007-07-11 11:16:51.000000000 +0000
> @@ -28,12 +28,6 @@
>  
>  #include <linux/timex.h>
>  
> -/*
> - * Documentation on HPET can be found at:
> - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> - */
> -
>  #define HPET_MMAP_SIZE	1024
>  
>  #define HPET_ID		0x000
> diff -pur linux/include/asm-x86_64/hpet.h linux.new/include/asm-x86_64/hpet.h
> --- linux/include/asm-x86_64/hpet.h	2007-07-11 11:16:07.000000000 +0000
> +++ linux.new/include/asm-x86_64/hpet.h	2007-07-11 11:17:03.000000000 +0000
> @@ -1,12 +1,6 @@
>  #ifndef _ASM_X8664_HPET_H
>  #define _ASM_X8664_HPET_H 1
>  
> -/*
> - * Documentation on HPET can be found at:
> - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> - */
> -
>  #define HPET_MMAP_SIZE	1024
>  
>  #define HPET_ID		0x000

It only half-applies here because 100 monkeys are tromping all over the
hpet code.

But I'm inclined to duck it anyway: having the documentation references in
the soruce doesn't hurt, and nobody looks in Documentation/.
