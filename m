Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbYHUPpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbYHUPpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHUPpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:45:43 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:64205 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750824AbYHUPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:45:42 -0400
Date: Thu, 21 Aug 2008 17:45:41 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Theodore Ts'o" <tytso@mit.edu>
cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: Re: UML build failure in 2.6.27-rc3
In-Reply-To: <E1KWBwC-0002dN-KE@closure.thunk.org>
Message-ID: <Pine.LNX.4.64.0808211742170.7646@vixen.sonytel.be>
References: <E1KWBwC-0002dN-KE@closure.thunk.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-855205982-1219333541=:7646"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-855205982-1219333541=:7646
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 21 Aug 2008, Theodore Ts'o wrote:
> Is this a known problem?
> 
>   SYMLINK arch/um/include/kern_constants.h
>   SYMLINK arch/um/include/sysdep
> make[2]: `arch/um/sys-i386/user-offsets.s' is up to date.
>   CHK     arch/um/include/user_constants.h
>   Using /usr/projects/linux/ext4 as source for kernel
>   GEN     /usr/projects/linux/uml/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    /usr/projects/linux/ext4/scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      arch/um/kernel/ptrace.o
> /usr/projects/linux/ext4/arch/um/kernel/ptrace.c:230: error: static declaration of ‘send_sigtrap’ follows non-static declaration
> include2/asm/ptrace-generic.h:51: error: previous declaration of ‘send_sigtrap’ was here
> make[2]: *** [arch/um/kernel/ptrace.o] Error 1
> make[1]: *** [arch/um/kernel] Error 2
> make: *** [sub-make] Error 2

At least I don't see it in 2.6.27-rc4, for both ia32 and amd64 UML builds.
I also had no build problems during the last few weeks.

Does you config differ a lot from the defconfig?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-855205982-1219333541=:7646--
