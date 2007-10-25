Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbXJYQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbXJYQEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbXJYQD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:03:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:10401 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbXJYQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iyJarf+RRy4Hf88Y5/HYWYYw9rtW82fgoqiiofnk690ZnigxWyqJldo00n3LwBPUzhEvpi927kN9WbNdXwqFdbYibb4d6RYD9iODy3ul8YD0Hdv7b9QdnCmtI2Wmw1S08j2rKqEqyJecpxbpOcnZCJv8eb0VpMLgYWueDH3Umj0=
Message-ID: <5d6222a80710250903y87f63f2g4193ab7161fb57c8@mail.gmail.com>
Date: Thu, 25 Oct 2007 14:03:56 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>
Subject: Re: [PATCH] Wipe out traditional opt from x86_64 Makefile
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <11933164723812-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11933164723812-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, ok... this was stupid.

I sent the patch against an already-commented out version, which is
the one I was using for testing. Really stupid.

On 10/25/07, Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
> Among other things, using -traditional as a gcc option stops us from
> using macro token pasting, which is a feature we heavily rely on.
>
> There was still a use of -traditional in arch/x86/kernel/Makefile_64,
> which this patch removes.
>
> I don't see any problems building kernels in my x86_64 box without
> -traditional.
>
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> ---
>  arch/x86/kernel/Makefile_64 |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
> index 82da906..03a01f6 100644
> --- a/arch/x86/kernel/Makefile_64
> +++ b/arch/x86/kernel/Makefile_64
> @@ -3,7 +3,6 @@
>  #
>
>  extra-y        := head_64.o head64.o init_task.o vmlinux.lds
> -#EXTRA_AFLAGS  := -traditional
>  obj-y  := process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
>                 ptrace_64.o time_64.o ioport_64.o ldt_64.o setup_64.o i8259_64.o sys_x86_64.o \
>                 x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
> --
> 1.4.4.2
>
>


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
