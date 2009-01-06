Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZAFFog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZAFFog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZAFFo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:44:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:1159 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZAFFo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MSSFv+TizGeFOQbdMM4C7z1fade2HElLKeb3anlqWlj8zG53dtR7AIibP1d81j5bNn
         lLUeT/45afbzjZoEMxUV5te+AiCx1RuSnxu2EO4mFPg7vIo0xsz16dk6zErcZPjrt1RA
         KcbPQUqnMC8Rc58D6LjdgQ6kjs7hk84gr/Z+0=
Message-ID: <3f9a31f40901052144k7af9966fx905e438f8b55744e@mail.gmail.com>
Date: Tue, 6 Jan 2009 11:14:25 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Huang Weiyi" <weiyi.huang@gmail.com>
Subject: Re: x86: remove duplicated #include's
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20090106065718.52C8.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090106065718.52C8.WEIYI.HUANG@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 4:28 AM, Huang Weiyi <weiyi.huang@gmail.com> wrote:
> Removed duplicated #include's in
>  arch/x86/kernel/mpparse.c
>  arch/x86/kernel/nmi.c
>
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
>
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index c5c5b8d..76ee713 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -17,7 +17,6 @@
>  #include <linux/acpi.h>
>  #include <linux/module.h>
>  #include <linux/smp.h>
> -#include <linux/acpi.h>
>
>  #include <asm/mtrr.h>
>  #include <asm/mpspec.h>
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 45a09cc..7228979 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -26,7 +26,6 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/kdebug.h>
>  #include <linux/smp.h>
> -#include <linux/nmi.h>
>
>  #include <asm/i8259.h>
>  #include <asm/io_apic.h>
>

Thanks Huang Weiyi.
--
JSR
