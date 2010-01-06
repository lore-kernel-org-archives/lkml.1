Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444Ab0AFWdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0AFWdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414Ab0AFWdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:33:31 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:34090 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0AFWda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:33:30 -0500
Date: Wed, 6 Jan 2010 23:33:17 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/3] generic sys_ipc wrapper
Message-ID: <20100106223317.GB11394@osiris.boeblingen.de.ibm.com>
References: <20100106172152.GC17163@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106172152.GC17163@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 06:21:52PM +0100, Christoph Hellwig wrote:
> 
> Add a generic implementation of the ipc demultiplexer syscall.  Except for
> s390 and sparc64 all implementations of the sys_ipc are nearly identical.
> [...]
> 
> Index: linux-2.6/arch/s390/include/asm/unistd.h
> ===================================================================
> --- linux-2.6.orig/arch/s390/include/asm/unistd.h	2010-01-04 15:57:16.673003737 +0100
> +++ linux-2.6/arch/s390/include/asm/unistd.h	2010-01-04 15:57:21.065006182 +0100
> @@ -381,6 +381,7 @@
>  #define __ARCH_WANT_OLD_READDIR
>  #define __ARCH_WANT_SYS_ALARM
>  #define __ARCH_WANT_SYS_GETHOSTNAME
> +#define __ARCH_WANT_SYS_IPC
>  #define __ARCH_WANT_SYS_PAUSE
>  #define __ARCH_WANT_SYS_SIGNAL
>  #define __ARCH_WANT_SYS_UTIME

This should be dropped then, I would guess?
