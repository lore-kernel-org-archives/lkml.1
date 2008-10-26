Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYJZKc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYJZKc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYJZKcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:32:21 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:50107 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbYJZKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:32:20 -0400
Message-ID: <20CDA8F07DE345B8AA01B3C43EE8A6F7@pc686xpp>
Reply-To: =?iso-8859-1?Q?J=F6rg_Dohle?= <j.d.-linux-kernel@arcor.de>
From: =?iso-8859-1?Q?J=F6rg_Dohle?= <j.d.-linux-kernel@arcor.de>
To: "Willy Tarreau" <w@1wt.eu>
Cc: <linux-kernel@vger.kernel.org>
References: <16891148.1224850600689.JavaMail.ngmail@webmail18.arcor-online.net> <20081024202955.GT24654@1wt.eu>
Subject: Re: How can I build a 2.4 kernel on a 2.6 System
Date: Sun, 26 Oct 2008 11:32:17 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Willy

Thanks for answering, but I have a problem with the compiling.
When I try to compile the 2.4 kernel with the following commands:

# make clean && make mrproper
then I restore the .config file
# make oldconfig
# make dep && make bzImage respectively make modules


 I get the following error message:

make[1]: Leaving directory 
`/fileserver/99_Frei/kernel-build-tree/linux-2.4.21-57.EL'
gcc -D__KERNEL__ -I/fileserver/99_Frei/kernel-build-tree/linux-2.4.21-57.EL/include 
 -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common 
  -Wno-unused -fomit-frame-pointer -pipe -freorder-blocks  -march=i386   -DKBUILD_BASENAME=main 
 -c -o init/main.o init/main.c
init/main.c:1: Fehler: Die ausgewählte CPU unterstützt nicht den x86-64 
Befehlssatz

English translation (by google)
init / main.c: 1: Error: The selected CPU does not support x86-64 
instruction


I use a x86_64 system with a 2.6.16.60-0.31-smp kernel for compiling 2.4 
kernel modules.

I think some compiler information are missing for make.

Could you help me?


----- Original Message ----- 
From: "Willy Tarreau" <w@1wt.eu>
To: <j.d.-linux-kernel@arcor.de>
Cc: <linux-kernel@vger.kernel.org>
Sent: Friday, October 24, 2008 9:29 PM
Subject: Re: How can I build a 2.4 kernel on a 2.6 System


> Hi,
>
> On Fri, Oct 24, 2008 at 02:16:40PM +0200, j.d.-linux-kernel@arcor.de 
> wrote:
>> Hello list
>>
>> I will build some 2.4 kernel modules on a system with a running 2.6 
>> kernel.
>>
>> Is it possible and how can I do this?
>
> Not sure what you really mean. If you mean build 2.4 modules for 2.4 on
> a machine running 2.6, that's OK as there's no dependency between the
> running kernel and the one you're building. However, you should be
> careful about two things :
>  - gcc: it tends to be too recent for 2.4. gcc 4.1 is the highest version
>    supported.
>  - modutils: most recent distros only ship module-init-tools without the
>    old depmod. If you intend to "make modules_install 
> INSTALL_MOD_PATH=..."
>    then get prepared to see some errors from depmod at the end. The 
> easiest
>    solution consists in getting a depmod from an old machine an installing
>    it in /tmp for instance.
>
> Hoping this helps,
> Willy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

