Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbXJZBx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbXJZBx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXJZBxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:53:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:64377 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbXJZBxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KXFtCXufVOp2OlhjaGEeGFMfABgyIyFa3LABL67ZnDdLu9BfTdEDotiDnaJuwnUlGsXPjyKVHwIPrYNZw8WO8E93R88XAaXFrEXCu6TQYjfhrxaP4BSZxPrTccfMaHTImwHpmvK90Zl8pPJM6jL0VbM+CJvYWGLDS//H2IsC3MA=
Message-ID: <86802c440710251853w1b33ea66j13181664cb5a30a0@mail.gmail.com>
Date: Thu, 25 Oct 2007 18:53:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 5/6] x86: move i386 and x86_64 Kconfig files to x86 directory
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <20071025200546.GF14501@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025195644.GA14501@uranus.ravnborg.org>
	 <20071025200546.GF14501@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> From 6654a98eb8587f0538904c9bdb9aeaf9d577f182 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Thu, 25 Oct 2007 21:04:16 +0200
> Subject: [PATCH] x86: move i386 and x86_64 Kconfig files to x86 directory
>
> After a small change in kconfig Makefile we could
> move all x86 Kconfig files to x86 directory.
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/{i386 => x86}/Kconfig.cpu              |    0
>  arch/{i386 => x86}/Kconfig.debug            |    0
>  arch/{i386/Kconfig => x86/Kconfig.i386}     |    4 +-
>  arch/{x86_64/Kconfig => x86/Kconfig.x86_64} |    2 +-
>  arch/x86_64/Kconfig.debug                   |  119 ---------------------------
>  scripts/kconfig/Makefile                    |    7 ++-
>  6 files changed, 9 insertions(+), 123 deletions(-)
>  rename arch/{i386 => x86}/Kconfig.cpu (100%)
>  rename arch/{i386 => x86}/Kconfig.debug (100%)
>  rename arch/{i386/Kconfig => x86/Kconfig.i386} (99%)
>  rename arch/{x86_64/Kconfig => x86/Kconfig.x86_64} (99%)
>  delete mode 100644 arch/x86_64/Kconfig.debug

arch/i386/Kconfig.debug will be arch/x86/Kconfig.debug

in it, EARLY_PRINTK will depend on X86_32

YH
