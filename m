Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYGTKIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYGTKIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 06:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYGTKIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 06:08:32 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:42416
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbYGTKIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 06:08:31 -0400
Date: Sun, 20 Jul 2008 11:00:39 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       matthew@wil.cx, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       chris@zankel.net
Subject: Re: [PATCH] Introducing asm/syscalls.h
Message-ID: <20080720100039.GA12514@linux-mips.org>
References: <1216544940.12650.13.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216544940.12650.13.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 02:39:00PM +0530, Jaswinder Singh wrote:
> From: Jaswinder Singh <jaswinder@infradead.org>
> Date: Sun, 20 Jul 2008 14:39:00 +0530
> To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
> 	David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
> 	rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
> 	starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
> 	tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
> 	ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
> 	schwidefsky@de.ibm.com, lethal@linux-sh.org, chris@zankel.net
> Subject: [PATCH] Introducing asm/syscalls.h
> Content-Type: text/plain
> 
> 
> Declaring arch-dependent syscalls for all architectures
> Beneficial for kernel and userspace
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

You write beneficial for userspace - but don't add <asm/syscall.h> to
include/asm-generic/Kbuild.asm.  Fortunately.  I doubt there is any good
reason for userspace to know about kernel prototypes.  For configurations
where userspace and kernel API differ - think 32-bit code running on a
64-bit kernel or similar - that would be a receipe for disaster.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
