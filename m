Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbXJMR1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbXJMR1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXJMR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:26:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:46532 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXJMR0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=nuh3yVjB3Vh3ByYpHFJRxgNwnoM9nVSeFsFr5hMWVZWOv9jSBDCAK07xc9IQRK+FZpE78KQuDwnRwTC6SJeds8PW8VqTSlRN7p5K7h4wdFefoWEijuoACvY2dFvbRbf7EUtAXnk0kaZ+ved06E+KV1J7FF4CF2/FMN+UyPzp90A=
Date: Sat, 13 Oct 2007 19:35:01 -0700
To: animesh.saxena@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Compiling kernel 2.6.23.1 HELP
Message-Id: <20071013193501.03d0ce14.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <1192293968.16391.9.camel@localhost.localdomain>
References: <20071004035935.042951211@sgi.com>
	<20071004040003.303112696@sgi.com>
	<1192293968.16391.9.camel@localhost.localdomain>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This is not the proper forum for compilation help (if nothing is broken of course). You would probably get good help asking on fedora forum (or simply do a search there). Looking at your log it seems to more reflect headers missing than anything wrong with the kernel in it self.

If you fail to find anything useful, I can help you but please send me mail directly so we don't put additional weight on 
this mailinglist.

Best wishes
Kristoffer Ericson

On Sat, 13 Oct 2007 22:16:08 +0530
animesh saxena <animesh.saxena@gmail.com> wrote:

> Hi,
>    I am a kernel newbie, so need some help trying to compile it. 
> I have fedora 7 installed. 
> 
> While compiling it, I get errors as follows.....
> 
>  HOSTCC  scripts/basic/fixdep
> scripts/basic/fixdep.c:107:23: error: sys/types.h: No such file or
> directory
> scripts/basic/fixdep.c:108:22: error: sys/stat.h: No such file or
> directory
> scripts/basic/fixdep.c:109:22: error: sys/mman.h: No such file or
> directory
> scripts/basic/fixdep.c:110:20: error: unistd.h: No such file or
> directory
> scripts/basic/fixdep.c:111:19: error: fcntl.h: No such file or directory
> scripts/basic/fixdep.c:112:20: error: string.h: No such file or
> directory
> scripts/basic/fixdep.c:113:20: error: stdlib.h: No such file or
> directory
> scripts/basic/fixdep.c:114:19: error: stdio.h: No such file or directory
> In file included
> from /usr/lib/gcc/x86_64-redhat-linux/4.1.2/include/syslimits.h:7,
> 
> from /usr/lib/gcc/x86_64-redhat-linux/4.1.2/include/limits.h:11,
>                  from scripts/basic/fixdep.c:115:
> /usr/lib/gcc/x86_64-redhat-linux/4.1.2/include/limits.h:122:61: error:
> limits.h: No such file or directory
> scripts/basic/fixdep.c:116:19: error: ctype.h: No such file or directory
> scripts/basic/fixdep.c:117:23: error: arpa/inet.h: No such file or
> directory
> scripts/basic/fixdep.c: In function ‘usage’:
> scripts/basic/fixdep.c:131: warning: implicit declaration of function
> ‘fprintf’
> scripts/basic/fixdep.c:131: warning: incompatible implicit declaration
> of built-in function ‘fprintf’
> scripts/basic/fixdep.c:131: error: ‘stderr’ undeclared (first use in
> this function)
> scripts/basic/fixdep.c:131: error: (Each undeclared identifier is
> reported only once
> scripts/basic/fixdep.c:131: error: for each function it appears in.)
> scripts/basic/fixdep.c:132: warning: implicit declaration of function
> ‘exit’
> scripts/basic/fixdep.c:132: warning: incompatible implicit declaration
> of built-in function ‘exit’
> scripts/basic/fixdep.c: In function ‘print_cmdline’:
> scripts/basic/fixdep.c:140: warning: implicit declaration of function
> ‘printf’
> scripts/basic/fixdep.c:140: warning: incompatible implicit declaration
> of built-in function ‘printf’
> scripts/basic/fixdep.c: At top level:
> scripts/basic/fixdep.c:143: error: ‘NULL’ undeclared here (not in a
> function)
> scripts/basic/fixdep.c: In function ‘grow_config’:
> scripts/basic/fixdep.c:156: warning: implicit declaration of function
> ‘realloc’
> scripts/basic/fixdep.c:156: warning: assignment makes pointer from
> integer without a cast
> scripts/basic/fixdep.c:158: warning: implicit declaration of function
> ‘perror’
> scripts/basic/fixdep.c:158: warning: incompatible implicit declaration
> of built-in function ‘exit’
> scripts/basic/fixdep.c: In function ‘is_defined_config’:
> scripts/basic/fixdep.c:174: warning: implicit declaration of function
> ‘memcmp’
> scripts/basic/fixdep.c: In function ‘define_config’:
> scripts/basic/fixdep.c:187: warning: implicit declaration of function
> ‘memcpy’
> scripts/basic/fixdep.c:187: warning: incompatible implicit declaration
> of built-in function ‘memcpy’
> scripts/basic/fixdep.c: In function ‘use_config’:
> scripts/basic/fixdep.c:206: error: ‘PATH_MAX’ undeclared (first use in
> this function)
> scripts/basic/fixdep.c:214: warning: incompatible implicit declaration
> of built-in function ‘memcpy’
> scripts/basic/fixdep.c:220: warning: implicit declaration of function
> ‘tolower’
> scripts/basic/fixdep.c:222: warning: incompatible implicit declaration
> of built-in function ‘printf’
> scripts/basic/fixdep.c:206: warning: unused variable ‘s’
> scripts/basic/fixdep.c: At top level:
> scripts/basic/fixdep.c:225: error: expected declaration specifiers or
> ‘...’ before ‘size_t’
> scripts/basic/fixdep.c: In function ‘parse_config_file’:
> scripts/basic/fixdep.c:227: error: ‘len’ undeclared (first use in this
> function)
> scripts/basic/fixdep.c:233: warning: implicit declaration of function
> ‘ntohl’
> scripts/basic/fixdep.c:244: warning: implicit declaration of function
> ‘isalnum’
> scripts/basic/fixdep.c: In function ‘strrcmp’:
> scripts/basic/fixdep.c:261: warning: implicit declaration of function
> ‘strlen’
> scripts/basic/fixdep.c:261: warning: incompatible implicit declaration
> of built-in function ‘strlen’
> scripts/basic/fixdep.c: In function ‘do_config_file’:
> scripts/basic/fixdep.c:272: error: storage size of ‘st’ isn’t known
> scripts/basic/fixdep.c:276: warning: implicit declaration of function
> ‘open’
> scripts/basic/fixdep.c:276: error: ‘O_RDONLY’ undeclared (first use in
> this function)
> scripts/basic/fixdep.c:278: warning: incompatible implicit declaration
> of built-in function ‘fprintf’
> scripts/basic/fixdep.c:278: error: ‘stderr’ undeclared (first use in
> this function)
> 
> On many forums it said I need to have 2.4 kernel headers. I can't
> understand why is it so? Am I missing something?
> 
> I used git for getting the latest kernel. 
> 
> git-clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> Is there something similar for getting kernel headers? Please help. 
> 
> Thanks,
> Animesh Saxena
> 
> 
> 
> 
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
