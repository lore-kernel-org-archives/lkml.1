Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbXIEJSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbXIEJSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXIEJSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:18:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:21610 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbXIEJSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g+BbMgGq1+oHo5Gc+SfI2HjHVuBB8csV1Llz3+ygRHnQG7vpumVcFrC1Gfp6gTIn5xkE1WY0Z8NCU/XvfALIDO54lI01uXhozP87hfqcz66se3HOGcRSoPjZUQjj9DX5Fnt0h+u44JO2ZzvFls0wQjDxQU9aFe4DGg0qdRPgTXg=
Message-ID: <653402b90709050218v1b2db724na43dc342d4b8d408@mail.gmail.com>
Date: Wed, 5 Sep 2007 11:18:21 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Subject: Re: _syscall0 exists or obsolete in 2.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3f9a31f40709050140p698c37e3q403e2d1cadca1cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40709050140p698c37e3q403e2d1cadca1cf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/07, Jaswinder Singh <jaswinderlinux@gmail.com> wrote:
> Hello all,
>
> I am trying to add syscall in include/asm/unistd.h:

Which platform?

>
> static inline _syscall0(int,my_sys_call);
>
> But I am getting following errors :
>
>   AS      arch/arm/kernel/entry-common.o

Assuming arm, I don't see that include/asm-arm/unistd.h has 622 lines.

> include/asm/unistd.h: Assembler messages:
> include/asm/unistd.h:622: Error: bad instruction `static inline int
> my_sys_call(void){register long __res_r0 __asm__("r0")'
> include/asm/unistd.h:622: Error: bad instruction `long __res'
> include/asm/unistd.h:622: Error: bad instruction `__asm__
> __volatile__("swi\t""(0x900000+322)""":"=r"(__res_r0)::"memory")'
> include/asm/unistd.h:622: Error: bad instruction `do {if((unsigned
> long)(__res)>=(unsigned long)(-129)){errno=-(__res)'
> include/asm/unistd.h:622: Error: junk at end of line, first
> unrecognized character is `}'
> include/asm/unistd.h:622: Error: junk at end of line, first
> unrecognized character is `}'
> include/asm/unistd.h:622: Error: junk at end of line, first
> unrecognized character is `}'
> make[1]: *** [arch/arm/kernel/entry-common.o] Error 1
> make: *** [arch/arm/kernel] Error 2
>
>
> This was working in older versions.
>
> I am curious _syscall0 still exists or obsolete in 2.6 linux.
>
> And I have noticed even if I commented _syscall0 macro, I do not get
> any errors so no body is using it , then why _syscall0 is in kernel
> header files and what is the substitute of _syscall0.

Well, if you look at

http://lxr.linux.no/ident?i=_syscall0

it seems it is pretty obsolete.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
