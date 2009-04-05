Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZDECci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZDECci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 22:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZDECc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 22:32:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:26225 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbZDECc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 22:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T8yjKVEYUSZAHcAjp0jVydBLyeUUd+zUqVjyv2fTR29rYhgunt7yhbMyVSlaIB1V/u
         DiC1vN7b3z9RQY6C7MY01/EcypSdGwsKTtzOoD7Ih00PwJ9ObxfGstRK7jVRIe7xOy+M
         e+oFKDDQb8e3rjh5exPZkPry0IQxBXxUxiJws=
MIME-Version: 1.0
In-Reply-To: <20090404163612.GA17018@hack>
References: <d82e647a0904040828n27af9173t7239b1822e6dc9ca@mail.gmail.com>
	 <20090404163612.GA17018@hack>
Date: Sun, 5 Apr 2009 10:32:25 +0800
Message-ID: <d82e647a0904041932s5c194c34kbda033feae447585@mail.gmail.com>
Subject: Re: [BUG 2.6.29] make install failed
From: Ming Lei <tom.leiming@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/5 Américo Wang <xiyou.wangcong@gmail.com>:
> On Sat, Apr 04, 2009 at 11:28:05PM +0800, Ming Lei wrote:
>>commit 6bb597507f9839b1349878
>>
>>[lm@linux-lm linux-2.6]$ sudo make install
>>  CHK     include/linux/version.h
>>  CHK     include/linux/utsrelease.h
>>  UPD     include/linux/utsrelease.h
>>  SYMLINK include/asm -> include/asm-x86
>>  CALL    scripts/checksyscalls.sh
>>  CHK     include/linux/compile.h
>>  SKIPPED include/linux/compile.h
>>  CC      init/version.o
>>  LD      init/built-in.o
>>  CC      kernel/trace/trace.o
>>  LD      kernel/trace/built-in.o
>>  CC      kernel/module.o
>>  LD      kernel/built-in.o
>>
>>  LD      vmlinux.o
>>  MODPOST vmlinux.o
>>WARNING: modpost: Found 2 section mismatch(es).
>>To see full details build your kernel with:
>>'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>  GEN     .version
>>  CHK     include/linux/compile.h
>>  SKIPPED include/linux/compile.h
>>  LD      .tmp_vmlinux1
>>  KSYM    .tmp_kallsyms1.S
>>  AS      .tmp_kallsyms1.o
>>  LD      .tmp_vmlinux2
>>  KSYM    .tmp_kallsyms2.S
>>  AS      .tmp_kallsyms2.o
>>  LD      vmlinux
>>  SYSMAP  System.map
>>  SYSMAP  .tmp_System.map
>>sh /home/lm/git/linux-2.6/linux-2.6/arch/x86/boot/install.sh 2.6.29
>>arch/x86/boot/bzImage \
>>               System.map "/boot"
>>WARNING: Couldn't open directory /lib/modules/2.6.29: No such file or directory
>>FATAL: Could not open /lib/modules/2.6.29/modules.dep.temp for
>>writing: No such file or directory
>>No modules available for kernel "2.6.29".
>>mkinitrd failed
>
> Probably you forgot to do 'make modules_install'?

No, I really does make modules_install before make install.
I'll try it again.

Thanks!

>
>
> --
> Do what you love, f**k the rest! F**k the regulations!
>
>



-- 
Lei Ming
