Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXJMQqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXJMQqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 12:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXJMQq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 12:46:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:37493 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXJMQq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 12:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:in-reply-to:references:content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SISnVn3HY8CHGapXHOD8rEDjyrw/wFa8L1dohNnCAMK8RPtzRZqVaACbJR/lVbajLIvNHaztfKyctAMNDeqx2Oy4BV71hmZmEKe9nTUqyo4oy6nefPMRhT2+pu++7Z9TU5wlKLsvaV9YJfcA3YcutldujYNz/DgdmfkLoq38oJo=
Subject: Compiling kernel 2.6.23.1 HELP
From: animesh saxena <animesh.saxena@gmail.com>
Reply-To: animesh.saxena@gmail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071004040003.303112696@sgi.com>
References: <20071004035935.042951211@sgi.com>
	 <20071004040003.303112696@sgi.com>
Content-Type: text/plain; charset=UTF-8
Organization: Open Source
Date: Sat, 13 Oct 2007 22:16:08 +0530
Message-Id: <1192293968.16391.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I am a kernel newbie, so need some help trying to compile it. 
I have fedora 7 installed. 

While compiling it, I get errors as follows.....

 HOSTCC  scripts/basic/fixdep
scripts/basic/fixdep.c:107:23: error: sys/types.h: No such file or
directory
scripts/basic/fixdep.c:108:22: error: sys/stat.h: No such file or
directory
scripts/basic/fixdep.c:109:22: error: sys/mman.h: No such file or
directory
scripts/basic/fixdep.c:110:20: error: unistd.h: No such file or
directory
scripts/basic/fixdep.c:111:19: error: fcntl.h: No such file or directory
scripts/basic/fixdep.c:112:20: error: string.h: No such file or
directory
scripts/basic/fixdep.c:113:20: error: stdlib.h: No such file or
directory
scripts/basic/fixdep.c:114:19: error: stdio.h: No such file or directory
In file included
from /usr/lib/gcc/x86_64-redhat-linux/4.1.2/include/syslimits.h:7,

from /usr/lib/gcc/x86_64-redhat-linux/4.1.2/include/limits.h:11,
                 from scripts/basic/fixdep.c:115:
/usr/lib/gcc/x86_64-redhat-linux/4.1.2/include/limits.h:122:61: error:
limits.h: No such file or directory
scripts/basic/fixdep.c:116:19: error: ctype.h: No such file or directory
scripts/basic/fixdep.c:117:23: error: arpa/inet.h: No such file or
directory
scripts/basic/fixdep.c: In function ‘usage’:
scripts/basic/fixdep.c:131: warning: implicit declaration of function
‘fprintf’
scripts/basic/fixdep.c:131: warning: incompatible implicit declaration
of built-in function ‘fprintf’
scripts/basic/fixdep.c:131: error: ‘stderr’ undeclared (first use in
this function)
scripts/basic/fixdep.c:131: error: (Each undeclared identifier is
reported only once
scripts/basic/fixdep.c:131: error: for each function it appears in.)
scripts/basic/fixdep.c:132: warning: implicit declaration of function
‘exit’
scripts/basic/fixdep.c:132: warning: incompatible implicit declaration
of built-in function ‘exit’
scripts/basic/fixdep.c: In function ‘print_cmdline’:
scripts/basic/fixdep.c:140: warning: implicit declaration of function
‘printf’
scripts/basic/fixdep.c:140: warning: incompatible implicit declaration
of built-in function ‘printf’
scripts/basic/fixdep.c: At top level:
scripts/basic/fixdep.c:143: error: ‘NULL’ undeclared here (not in a
function)
scripts/basic/fixdep.c: In function ‘grow_config’:
scripts/basic/fixdep.c:156: warning: implicit declaration of function
‘realloc’
scripts/basic/fixdep.c:156: warning: assignment makes pointer from
integer without a cast
scripts/basic/fixdep.c:158: warning: implicit declaration of function
‘perror’
scripts/basic/fixdep.c:158: warning: incompatible implicit declaration
of built-in function ‘exit’
scripts/basic/fixdep.c: In function ‘is_defined_config’:
scripts/basic/fixdep.c:174: warning: implicit declaration of function
‘memcmp’
scripts/basic/fixdep.c: In function ‘define_config’:
scripts/basic/fixdep.c:187: warning: implicit declaration of function
‘memcpy’
scripts/basic/fixdep.c:187: warning: incompatible implicit declaration
of built-in function ‘memcpy’
scripts/basic/fixdep.c: In function ‘use_config’:
scripts/basic/fixdep.c:206: error: ‘PATH_MAX’ undeclared (first use in
this function)
scripts/basic/fixdep.c:214: warning: incompatible implicit declaration
of built-in function ‘memcpy’
scripts/basic/fixdep.c:220: warning: implicit declaration of function
‘tolower’
scripts/basic/fixdep.c:222: warning: incompatible implicit declaration
of built-in function ‘printf’
scripts/basic/fixdep.c:206: warning: unused variable ‘s’
scripts/basic/fixdep.c: At top level:
scripts/basic/fixdep.c:225: error: expected declaration specifiers or
‘...’ before ‘size_t’
scripts/basic/fixdep.c: In function ‘parse_config_file’:
scripts/basic/fixdep.c:227: error: ‘len’ undeclared (first use in this
function)
scripts/basic/fixdep.c:233: warning: implicit declaration of function
‘ntohl’
scripts/basic/fixdep.c:244: warning: implicit declaration of function
‘isalnum’
scripts/basic/fixdep.c: In function ‘strrcmp’:
scripts/basic/fixdep.c:261: warning: implicit declaration of function
‘strlen’
scripts/basic/fixdep.c:261: warning: incompatible implicit declaration
of built-in function ‘strlen’
scripts/basic/fixdep.c: In function ‘do_config_file’:
scripts/basic/fixdep.c:272: error: storage size of ‘st’ isn’t known
scripts/basic/fixdep.c:276: warning: implicit declaration of function
‘open’
scripts/basic/fixdep.c:276: error: ‘O_RDONLY’ undeclared (first use in
this function)
scripts/basic/fixdep.c:278: warning: incompatible implicit declaration
of built-in function ‘fprintf’
scripts/basic/fixdep.c:278: error: ‘stderr’ undeclared (first use in
this function)

On many forums it said I need to have 2.4 kernel headers. I can't
understand why is it so? Am I missing something?

I used git for getting the latest kernel. 

git-clone
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Is there something similar for getting kernel headers? Please help. 

Thanks,
Animesh Saxena








