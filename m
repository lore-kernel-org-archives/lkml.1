Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZDDQg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZDDQg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZDDQgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:36:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:35301 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZDDQgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A+TaBZ5jhDRgyhdYWrZYGxzYuBRyqD8OJFEMvFrUslqDZ4aLvh/qiYeWW/HCkWHWBk
         pCHdLx/4A2X+1OqiBS9a8P9wjHOZG4JWlWiBI2GMggBnNsLN0K+cSAEFyyo3m0VNhWJL
         RRrhMV2NbEUaDm+maHA5Lw/I15JykO00DWbh0=
Date: Sun, 5 Apr 2009 00:36:12 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 2.6.29] make install failed
Message-ID: <20090404163612.GA17018@hack>
References: <d82e647a0904040828n27af9173t7239b1822e6dc9ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0904040828n27af9173t7239b1822e6dc9ca@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 11:28:05PM +0800, Ming Lei wrote:
>commit 6bb597507f9839b1349878
>
>[lm@linux-lm linux-2.6]$ sudo make install
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  UPD     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-x86
>  CALL    scripts/checksyscalls.sh
>  CHK     include/linux/compile.h
>  SKIPPED include/linux/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  CC      kernel/trace/trace.o
>  LD      kernel/trace/built-in.o
>  CC      kernel/module.o
>  LD      kernel/built-in.o
>
>  LD      vmlinux.o
>  MODPOST vmlinux.o
>WARNING: modpost: Found 2 section mismatch(es).
>To see full details build your kernel with:
>'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>  GEN     .version
>  CHK     include/linux/compile.h
>  SKIPPED include/linux/compile.h
>  LD      .tmp_vmlinux1
>  KSYM    .tmp_kallsyms1.S
>  AS      .tmp_kallsyms1.o
>  LD      .tmp_vmlinux2
>  KSYM    .tmp_kallsyms2.S
>  AS      .tmp_kallsyms2.o
>  LD      vmlinux
>  SYSMAP  System.map
>  SYSMAP  .tmp_System.map
>sh /home/lm/git/linux-2.6/linux-2.6/arch/x86/boot/install.sh 2.6.29
>arch/x86/boot/bzImage \
>		System.map "/boot"
>WARNING: Couldn't open directory /lib/modules/2.6.29: No such file or directory
>FATAL: Could not open /lib/modules/2.6.29/modules.dep.temp for
>writing: No such file or directory
>No modules available for kernel "2.6.29".
>mkinitrd failed

Probably you forgot to do 'make modules_install'?


-- 
Do what you love, f**k the rest! F**k the regulations!
 
