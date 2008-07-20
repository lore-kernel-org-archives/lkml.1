Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbYGTNH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbYGTNH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 09:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbYGTNHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 09:07:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbYGTNHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 09:07:16 -0400
Subject: Re: [PATCH] Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       matthew@wil.cx, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       chris@zankel.net
In-Reply-To: <1216556263.2707.2.camel@jaswinder.satnam>
References: <1216544940.12650.13.camel@jaswinder.satnam>
	 <20080720100039.GA12514@linux-mips.org>
	 <1216556263.2707.2.camel@jaswinder.satnam>
Content-Type: text/plain; charset=utf8
Date: Sun, 20 Jul 2008 18:36:08 +0530
Message-Id: <1216559168.2707.9.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ralf,

On Sun, 2008-07-20 at 17:48 +0530, Jaswinder Singh wrote:
> > 
> > You write beneficial for userspace - but don't add <asm/syscall.h> to
> > include/asm-generic/Kbuild.asm.  
> 
> diff --git a/include/asm-generic/Kbuild.asm
> b/include/asm-generic/Kbuild.asm
> index 7cd25b8..af24926 100644
> --- a/include/asm-generic/Kbuild.asm
> +++ b/include/asm-generic/Kbuild.asm
> @@ -27,6 +27,7 @@ unifdef-y += socket.h
>  unifdef-y += sockios.h
>  unifdef-y += stat.h
>  unifdef-y += statfs.h
> +unifdef-y += syscalls.h
>  unifdef-y += termbits.h
>  unifdef-y += termios.h
>  unifdef-y += types.h
> 

I think, adding syscalls.h is not required in ﻿include/asm-generic/Kbuild.asm.
Beneficial to userspace, I mean for reference purpose only.

Thank you,

Jaswinder Singh.

