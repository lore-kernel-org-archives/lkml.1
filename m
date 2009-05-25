Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZEYVpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZEYVpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZEYVpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:45:14 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:58080 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZEYVpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HNBIDLNZqVM7dQeZeNlMge/Vz8/zlkmTJ4vgWeULABEDMceGCWBAZFMJnmkXSPdC6K
         vdTUzwBQG0LO16e+B85VNzkOqNMTeccmFaIN0usTq+8yrpac13MjLJVc37V3luP+XR3J
         OVnb9CTvuiLVuFCK+7xTUkgcWWi8Dn6ewR+FQ=
MIME-Version: 1.0
In-Reply-To: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
References: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
Date: Tue, 26 May 2009 06:45:12 +0900
Message-ID: <49b7c2350905251445n14397b82yc993f1a86d715d4d@mail.gmail.com>
Subject: Re: Unable to compile 2.6.30-rc7 on RHEL 4 - GCC 3.4.6
From: GeunSik Lim <leemgs1@gmail.com>
To: debian developer <debiandev@gmail.com>
Cc: linux kernel <kernelnewbies@nl.linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If you want to use recent kernel source 2.6.24/2.6.28,
I recommend that you have to update linux distribution from current
linux distribution to
RHEL 5.X ( or CENTOS 5.X) in my experience.

Refer to http://linuxdistrowatch.com website to select linux
distribution for you.

If you keep gcc 3.X.X to compile recent kernel source contiunally,
You will meet another problems again.

On Tue, May 26, 2009 at 1:56 AM, debian developer <debiandev@gmail.com> wrote:
> Hi all,
>
> I am getting this error when trying to compile the latest rc:
>
> /in/inndesk171/linux-2.6.28/arch/x86/Makefile:82: stack protector
> enabled but no compiler support
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-x86
>  CALL    scripts/checksyscalls.sh
>  CC      init/main.o
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h: In
> function `start_kernel':
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
> warning: asm operand 1 probably doesn't match constraints
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
> warning: asm operand 2 probably doesn't match constraints
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
> warning: asm operand 1 probably doesn't match constraints
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
> warning: asm operand 2 probably doesn't match constraints
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1599:
> warning: asm operand 1 probably doesn't match constraints
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
> error: impossible constraint in `asm'
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
> error: impossible constraint in `asm'
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
> error: impossible constraint in `asm'
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
> error: impossible constraint in `asm'
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1599:
> error: impossible constraint in `asm'
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
> warning: 'f' might be used uninitialized in this function
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
> warning: 'f' might be used uninitialized in this function
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
> warning: 'f' might be used uninitialized in this function
> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
> warning: 'f' might be used uninitialized in this function
> make[1]: *** [init/main.o] Error 1
> make: *** [init] Error 2
>
>
> The gcc version is as follows:
> debiandev@inndesk171[80] gcc -v
> Reading specs from /usr/lib/gcc/x86_64-redhat-linux/3.4.6/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> --infodir=/usr/share/info --enable-shared --enable-threads=posix
> --disable-checking --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-java-awt=gtk
> --host=x86_64-redhat-linux
> Thread model: posix
> gcc version 3.4.6 20060404 (Red Hat 3.4.6-9)
>
>
> Is this gcc version no longer usable to compile the latest kernel?
>
> Thanks,
> DD
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
