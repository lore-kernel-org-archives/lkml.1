Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYGDMkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYGDMkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYGDMkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:40:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:8177 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbYGDMkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FQvKQdSEjo0QdBCoy2b2JwTiHUTuwhBkqQ0jkoi3xmgorCPsXB27YcJZ5vlaTUcSOc
         uaCq1NO2wWcM6qepwokrKCPF88VL+3s9yrwn+ZJMqseu61nsTHxIR7BRhzW+PHNOAJCz
         9Z1G7aHtmC7jDgduuUs1K9MEJErQDEhitP6/Q=
Message-ID: <e2e108260807040540hc66f43fs86419efeff8e8698@mail.gmail.com>
Date: Fri, 4 Jul 2008 14:40:20 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jesper Juhl" <trivial@kernel.org>
Subject: Re: [PATCH 2.6.26-rc3] Suppress files generated during x86_64 build process in Documentation/dontdiff
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200805200852.51831.bart.vanassche@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805200852.51831.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jesper,

Have you already had the time to look at the patch below ?

Bart.

On Tue, May 20, 2008 at 8:52 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> Suppress the following additional files generated during an x86_64 kernel
> build in Documentation/dontdiff: bounds.h, cpustr.h, mkcpustr, vdso-syms.lds,
> vdso.so.dbg, vdso32-syms.lds, vdso32-syscall-syms.lds, vdso32-syscall.so.dbg,
> vdso32-sysenter-syms.lds, vdso32-sysenter.so.dbg, vdso32.lds, wakeup.elf
> and wakeup.lds
>
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
>
> diff -uprN -X Documentation/dontdiff ../orig/linux-2.6.26-rc3/Documentation/dontdiff ./Documentation/dontdiff
> --- ../orig/linux-2.6.26-rc3/Documentation/dontdiff     2008-05-20 08:23:09.000000000 +0200
> +++ ./Documentation/dontdiff    2008-05-20 08:48:39.000000000 +0200
> @@ -72,6 +72,7 @@ bbootsect
>  bin2c
>  binkernel.spec
>  bootsect
> +bounds.h
>  bsetup
>  btfixupprep
>  build
> @@ -87,6 +88,7 @@ config_data.h*
>  config_data.gz*
>  conmakehash
>  consolemap_deftbl.c*
> +cpustr.h
>  crc32table.h*
>  cscope.*
>  defkeymap.c*
> @@ -136,6 +138,7 @@ miboot*
>  mk_elfconfig
>  mkboot
>  mkbugboot
> +mkcpustr
>  mkdep
>  mkprep
>  mktables
> @@ -177,7 +180,15 @@ times.h*
>  tkparse
>  trix_boot.h
>  utsrelease.h*
> +vdso-syms.lds
>  vdso.lds
> +vdso.so.dbg
> +vdso32-syms.lds
> +vdso32-syscall-syms.lds
> +vdso32-syscall.so.dbg
> +vdso32-sysenter-syms.lds
> +vdso32-sysenter.so.dbg
> +vdso32.lds
>  version.h*
>  vmlinux
>  vmlinux-*
> @@ -185,6 +196,8 @@ vmlinux.aout
>  vmlinux*.lds*
>  vmlinux*.scr
>  vsyscall.lds
> +wakeup.elf
> +wakeup.lds
>  wanxlfw.inc
>  uImage
>  unifdef
