Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZAKNX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZAKNX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZAKNXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:23:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:36220 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZAKNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KYggeVm1tRVUH8XOdcMemzh0emw6TiY8CoS50OqzrMW0W67NytXGG+bXosvhDWCLf4
         VBTN99VRJionlaUbNUtOi6VucxV+Mja17DikicsBpz7miQh9Qd4qu4aS4QtJQbkqMzZI
         xIg4YRvnOS39JJlFUU4RHtwdmosA4aJsUso1g=
Message-ID: <3f9a31f40901110523m12b48cc5tf6d1d2309c21411a@mail.gmail.com>
Date: Sun, 11 Jan 2009 18:53:47 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Petr Titera" <P.Titera@century.cz>
Subject: Re: Linux 2.6.29-rc1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4969E4D7.5050802@century.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
	 <4969E4D7.5050802@century.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 5:53 PM, Petr Titera <P.Titera@century.cz> wrote:
> Unfortunatelly it cannot be built without SMP support. This patch seems to
> fix it:
>
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index b824669..fd51bb9 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -11,6 +11,8 @@
> #include <linux/list.h>
> #include <linux/cpumask.h>
>
> +#include <asm/smp.h>
> +
> extern void cpu_idle(void);
>
> struct call_single_data {
> @@ -30,7 +32,6 @@ extern unsigned int total_cpus;
> #include <linux/kernel.h>
> #include <linux/compiler.h>
> #include <linux/thread_info.h>
> -#include <asm/smp.h>
>
> /*
>  * main cross-CPU interfaces, handles INIT, TLB flush, STOP, etc.
>
>

No, this is totally wrong, please check my patch in Subject "Build
error on latest git"

--
JSR
