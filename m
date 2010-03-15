Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915Ab0COH02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:26:28 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:37855 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759616Ab0COH0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JMT/y1qM5MQh6P2h5nyQqqEZYUPEXaRqiUs6xnZa/bn8CDJMNuS1W3M07d0aIxzv7K
         V3JqSVxdjLzlkZcen5IoKanKnlduWgVXwDilAhL7PHKFCzFk3y0d9l9Of88RtOCmLI5H
         lJQNVo2GiPMm8TvqDy7hrK66RavS62lbx1Pu0=
MIME-Version: 1.0
In-Reply-To: <4B9DDCD8.4070902@orcon.net.nz>
References: <4B9DDCD8.4070902@orcon.net.nz>
Date: Mon, 15 Mar 2010 12:56:24 +0530
Message-ID: <3f9a31f41003150026j6adba38em1e08e8e788c7c063@mail.gmail.com>
Subject: Re: Alpha: Compilation error 2.6.34-rc1 git a3d3203e4b
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 12:38 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> Compilation error while compiling latest kernel (commit a3d3203e4b) on
> Alpha:
>
>  CC      init/do_mounts.o
> In file included from
> /home/mjc/linux/linux-git/arch/alpha/include/asm/dma-mapping.h:13,
>                 from include/linux/dma-mapping.h:103,
>                 from
> /home/mjc/linux/linux-git/arch/alpha/include/asm/pci.h:7,
>                 from include/linux/pci.h:1209,
>                 from
> /home/mjc/linux/linux-git/arch/alpha/include/asm/core_tsunami.h:5,
>                 from
> /home/mjc/linux/linux-git/arch/alpha/include/asm/io.h:229,
>                 from include/linux/scatterlist.h:8,
>                 from include/linux/sunrpc/xdr.h:15,
>                 from include/linux/sunrpc/sched.h:17,
>                 from include/linux/sunrpc/auth.h:14,
>                 from include/linux/nfs_fs.h:47,
>                 from init/do_mounts.c:19:
> include/asm-generic/dma-mapping-common.h: In function ‘dma_map_sg_attrs’:
> include/asm-generic/dma-mapping-common.h:49: error: implicit declaration of
> function ‘for_each_sg’
> include/asm-generic/dma-mapping-common.h:50: error: expected ‘;’ before
> ‘kmemcheck_mark_initialized’
> make[1]: *** [init/do_mounts.o] Error 1
>
> I note that for_each_sg is defined in include/linux/scatterlist.h, which
> arch/alpha/include/asm/dma-mapping.h attempts to load, however
> include/linux/scatterlist.h was the one that included (indirectly)
> arch/alpha/include/asm/dma-mapping.h.  There is therefore a complete loop of
> includes from include/linux/scatterlist.h back to itself.
>

CCing to concern person.

--
JSR
