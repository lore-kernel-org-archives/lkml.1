Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXIEJh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXIEJh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbXIEJhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:37:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:35533 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbXIEJhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kaGJsVdU7ng2CA1NHaQyuV+Blr/GfrrVb37QA6hSWdLMRHb86I+2GKab9qOc7mj0ZZ7jHfTLJbeQ732goQtLO8KCWPdt+Mm2qiSlc2xN1XGA1aTzr4iRPEQSfKX+a/QT5nEXosaxz6Na/uQrmy4fyVt/BRvfiutQGHMhiRUJQbs=
Message-ID: <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com>
Date: Wed, 5 Sep 2007 11:37:15 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: building a specific in-tree module is currently a bit broken
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Adding K{build,config} wizards to CC]

On 05/09/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>   i know sam ravnborg has been Cc'ed on a janitors list posting
> mentioning this but, just in case this note can get a fix snuck in
> there quickly before 2.6.23 (this is on i386, but i'm guessing applies
> to all arches):
>
> $ make distclean
> $ make defconfig
> $ make menuconfig      (select visor.ko to be built a module)
> $ make drivers/usb/serial/visor.ko
> scripts/kconfig/conf -s arch/i386/Kconfig
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-i386
>   CC      arch/i386/kernel/asm-offsets.s
>   GEN     include/asm-i386/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CC      scripts/mod/empty.o
>   HOSTCC  scripts/mod/mk_elfconfig
>   MKELF   scripts/mod/elfconfig.h
>   HOSTCC  scripts/mod/file2alias.o
>   HOSTCC  scripts/mod/modpost.o
>   HOSTCC  scripts/mod/sumversion.o
>   HOSTLD  scripts/mod/modpost
>   HOSTCC  scripts/kallsyms
>   HOSTCC  scripts/conmakehash
>   HOSTCC  scripts/bin2c
>   CC [M]  drivers/usb/serial/visor.o
> /bin/sh: .tmp_versions/visor.mod: No such file or directory
>   MODPOST 0 modules
> $
>
>   whoops.  manually creating the directory .tmp_versions first fixes
> this, but i'm not conversant enough with the Makefile to want to take
> a shot at repairing this.
>
> rday
>
> --
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
>
> http://crashcourse.ca

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
