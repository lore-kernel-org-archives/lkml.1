Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbZLRFul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbZLRFul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZLRFuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:50:40 -0500
Received: from ns3.baby-dragons.com ([64.62.236.141]:57669 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZLRFuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:50:39 -0500
Date: Thu, 17 Dec 2009 20:50:37 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [kernel] linux-2.6.32.1 "make V=1 menuconfig" errors ,  Huh
 ?-(
In-Reply-To: <alpine.LNX.2.01.0912171418380.9874@filesrv1.baby-dragons.com>
Message-ID: <alpine.LNX.2.01.0912172045360.9874@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912171418380.9874@filesrv1.baby-dragons.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (ns3.baby-dragons.com [64.62.236.141]); Fri, 18 Dec 2009 05:50:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	 	Hello All ,

On Thu, 17 Dec 2009, Mr. James W. Laferriere wrote:
>
> 	Some pertinant info ...
> # scripts/ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux (none) 2.6.30.6 #1 SMP Sun Oct 11 18:36:23 UTC 2009 i686 pentium4 i386 
> GNU/Linux
>
> Gnu C                  3.4.6
> Gnu make               3.81
> binutils               2.15.92.0.2
> util-linux             2.12r
> mount                  2.12r
> module-init-tools      3.2.2
> e2fsprogs              1.38
> jfsutils               1.1.11
> reiserfsprogs          3.6.19
> xfsprogs               2.8.10
> pcmciautils            014
> pcmcia-cs              3.2.8
> quota-tools            3.13.
> PPP                    2.4.4
> Linux C Library        2.3.6
> Dynamic linker (ldd)   2.3.6
> Linux C++ Library      6.0.3
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.1
> Sh-utils               5.97
> udev                   097
> Modules Loaded
>
> 	The errors ,  Quite a mouth full of them .  NEVER seen menuconfig 
> spit all this sh?t out before .
> 	Can someone enlighten me as to what I've got that is broken or ... ?
> 			Tia ,  JimL

 	For someone elses benefit these are symptomatic of butchered header 
file directory contents .  Cure was to reinstall the base header file packages .
 	This was caused by an attempt (2.6.28 days) to do a "make 
INSTALL_HDR_PATH=/usr headers_install" which was uneducated .  And still do NOT 
see a document covering WHEN such a header install would/should be necessary .
 	If I am just being blind PLEASE guide me to the document in the kernel 
tree so I can rectify my ignorance .

 		Twyl ,  JimL

> # make V=1 menuconfig
> make -f scripts/Makefile.build obj=scripts/basic
>  gcc -Wp,-MD,scripts/basic/.fixdep.d -Wall -Wmissing-prototypes 
> -Wstrict-prototypes -O2 -fomit-frame-pointer     -o scripts/basic/fixdep 
> scripts/basic/fixdep.c
> In file included from scripts/basic/fixdep.c:106:
> /usr/include/sys/types.h:27:22: features.h: No such file or directory
> In file included from /usr/include/bits/types.h:31,
>                 from /usr/include/sys/types.h:31,
>                 from scripts/basic/fixdep.c:106:
> /usr/lib/gcc/i486-slackware-linux/3.4.6/include/stddef.h:213: error: syntax 
> error before "typedef"
> /usr/include/sys/types.h:133:18: time.h: No such file or directory
> /usr/include/sys/types.h:158:20: missing binary operator before token "("
> In file included from scripts/basic/fixdep.c:107:
> /usr/include/sys/stat.h:103: error: syntax error before "__BEGIN_DECLS"
> In file included from /usr/include/sys/stat.h:105,
>                 from scripts/basic/fixdep.c:107:
> /usr/include/bits/stat.h:36: error: syntax error before "struct"
> In file included from scripts/basic/fixdep.c:107:
> /usr/include/sys/stat.h:208: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:212: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:257: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:275: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:285: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:298: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:325: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:327: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:329: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:358: error: syntax error before "__THROW"
> /usr/include/sys/stat.h:364: error: syntax error before '(' token
> /usr/include/sys/stat.h:378: error: syntax error before '(' token
> In file included from scripts/basic/fixdep.c:108:
> /usr/include/sys/mman.h:58: error: syntax error before "extern"
> /usr/include/sys/mman.h:59: error: syntax error before "__THROW"
> /usr/include/sys/mman.h:77: error: syntax error before "__THROW"
> /usr/include/sys/mman.h:82: error: syntax error before "__THROW"
> /usr/include/sys/mman.h:104: error: syntax error before "__THROW"
> /usr/include/sys/mman.h:107: error: syntax error before "__THROW"
> /usr/include/sys/mman.h:112: error: syntax error before "__THROW"
> /usr/include/sys/mman.h:116: error: syntax error before "__THROW"
> scripts/basic/fixdep.c:109:20: unistd.h: No such file or directory
> scripts/basic/fixdep.c:110:19: fcntl.h: No such file or directory
> scripts/basic/fixdep.c:111:20: string.h: No such file or directory
> scripts/basic/fixdep.c:112:20: stdlib.h: No such file or directory
> scripts/basic/fixdep.c:113:19: stdio.h: No such file or directory
> In file included from 
> /usr/lib/gcc/i486-slackware-linux/3.4.6/include/syslimits.h:7,
>                 from 
> /usr/lib/gcc/i486-slackware-linux/3.4.6/include/limits.h:11,
>                 from scripts/basic/fixdep.c:114:
> /usr/lib/gcc/i486-slackware-linux/3.4.6/include/limits.h:122:61: limits.h: No 
> such file or directory
> scripts/basic/fixdep.c:115:19: ctype.h: No such file or directory
> In file included from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/netinet/in.h:23:20: stdint.h: No such file or directory
> In file included from /usr/include/netinet/in.h:24,
>                 from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/sys/socket.h:25: error: syntax error before "__BEGIN_DECLS"
> In file included from /usr/include/sys/uio.h:29,
>                 from /usr/include/sys/socket.h:27,
>                 from /usr/include/netinet/in.h:24,
>                 from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/bits/uio.h:42: error: syntax error before "struct"
> In file included from /usr/include/sys/socket.h:35,
>                 from /usr/include/netinet/in.h:24,
>                 from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/bits/socket.h:36: error: syntax error before "typedef"
> In file included from /usr/include/sys/socket.h:35,
>                 from /usr/include/netinet/in.h:24,
>                 from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/bits/socket.h:237: error: syntax error before "__flexarr"
> /usr/include/bits/socket.h:258: error: syntax error before "__THROW"
> In file included from /usr/include/netinet/in.h:24,
>                 from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/sys/socket.h:65:43: missing binary operator before token "("
> In file included from /usr/include/netinet/in.h:24,
>                 from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/sys/socket.h:100: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:107: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:111: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:115: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:129: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:187: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:193: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:199: error: syntax error before "__THROW"
> /usr/include/sys/socket.h:218: error: syntax error before "__THROW"
> In file included from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/netinet/in.h:28: error: syntax error before "__BEGIN_DECLS"
> /usr/include/netinet/in.h:31: error: syntax error before "enum"
> /usr/include/netinet/in.h:92: error: syntax error before "in_port_t"
> /usr/include/netinet/in.h:136: error: syntax error before "in_addr_t"
> /usr/include/netinet/in.h:139: error: syntax error before "in_addr_t"
> /usr/include/netinet/in.h:197: error: syntax error before "uint8_t"
> /usr/include/netinet/in.h:199: error: syntax error before "u6_addr32"
> /usr/include/netinet/in.h:200: error: syntax error before '}' token
> /usr/include/netinet/in.h:204: error: syntax error before '}' token
> /usr/include/netinet/in.h:222: error: syntax error before "in_port_t"
> /usr/include/netinet/in.h:229: error: invalid application of `sizeof' to 
> incomplete type `in_addr'
> /usr/include/netinet/in.h:230: error: syntax error before '}' token
> /usr/include/netinet/in.h:236: error: syntax error before "in_port_t"
> /usr/include/netinet/in.h:239: error: syntax error before "sin6_scope_id"
> /usr/include/netinet/in.h:247: error: field `imr_multiaddr' has incomplete 
> type
> /usr/include/netinet/in.h:250: error: field `imr_interface' has incomplete 
> type
> /usr/include/netinet/in.h:256: error: field `imr_multiaddr' has incomplete 
> type
> /usr/include/netinet/in.h:259: error: field `imr_interface' has incomplete 
> type
> /usr/include/netinet/in.h:262: error: field `imr_sourceaddr' has incomplete 
> type
> /usr/include/netinet/in.h:269: error: field `ipv6mr_multiaddr' has incomplete 
> type
> /usr/include/netinet/in.h:280: error: syntax error before "uint32_t"
> /usr/include/netinet/in.h:284: error: syntax error before '}' token
> /usr/include/netinet/in.h:289: error: syntax error before "uint32_t"
> /usr/include/netinet/in.h:296: error: syntax error before '}' token
> /usr/include/netinet/in.h:303: error: field `imsf_multiaddr' has incomplete 
> type
> /usr/include/netinet/in.h:306: error: field `imsf_interface' has incomplete 
> type
> /usr/include/netinet/in.h:309: error: syntax error before "uint32_t"
> /usr/include/netinet/in.h:315: error: syntax error before '}' token
> /usr/include/netinet/in.h:324: error: syntax error before "uint32_t"
> /usr/include/netinet/in.h:330: error: syntax error before "gf_fmode"
> /usr/include/netinet/in.h:333: error: syntax error before "gf_numsrc"
> /usr/include/netinet/in.h:336: error: syntax error before '}' token
> In file included from /usr/include/netinet/in.h:345,
>                 from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/bits/in.h:84: error: field `ip_dst' has incomplete type
> /usr/include/bits/in.h:91: error: field `imr_multiaddr' has incomplete type
> /usr/include/bits/in.h:92: error: field `imr_address' has incomplete type
> /usr/include/bits/in.h:100: error: field `ipi_spec_dst' has incomplete type
> /usr/include/bits/in.h:101: error: field `ipi_addr' has incomplete type
> In file included from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/netinet/in.h:354: error: syntax error before "ntohl"
> /usr/include/netinet/in.h:354: error: syntax error before "__netlong"
> /usr/include/netinet/in.h:355: error: syntax error before "ntohs"
> /usr/include/netinet/in.h:355: error: syntax error before "__netshort"
> /usr/include/netinet/in.h:357: error: syntax error before "htonl"
> /usr/include/netinet/in.h:357: error: syntax error before "__hostlong"
> /usr/include/netinet/in.h:359: error: syntax error before "htons"
> /usr/include/netinet/in.h:359: error: syntax error before "__hostshort"
> In file included from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/netinet/in.h:362:20: endian.h: No such file or directory
> In file included from /usr/include/arpa/inet.h:23,
>                 from scripts/basic/fixdep.c:116:
> /usr/include/netinet/in.h:428: error: syntax error before "__THROW"
> /usr/include/netinet/in.h:432: error: syntax error before "__THROW"
> /usr/include/netinet/in.h:458: error: field `ipi6_addr' has incomplete type
> In file included from scripts/basic/fixdep.c:116:
> /usr/include/arpa/inet.h:31: error: syntax error before "__BEGIN_DECLS"
> /usr/include/arpa/inet.h:35: error: syntax error before "extern"
> /usr/include/arpa/inet.h:35: error: syntax error before "__THROW"
> /usr/include/arpa/inet.h:38: error: syntax error before "inet_lnaof"
> /usr/include/arpa/inet.h:38: error: syntax error before "__THROW"
> /usr/include/arpa/inet.h:42: error: syntax error before "__net"
> /usr/include/arpa/inet.h:46: error: syntax error before "inet_netof"
> /usr/include/arpa/inet.h:46: error: syntax error before "__THROW"
> /usr/include/arpa/inet.h:50: error: syntax error before "inet_network"
> /usr/include/arpa/inet.h:50: error: syntax error before "__THROW"
> /usr/include/arpa/inet.h:54: error: syntax error before "__THROW"
> /usr/include/arpa/inet.h:60: error: syntax error before "__THROW"
> /usr/include/arpa/inet.h:67: error: syntax error before "__THROW"
> scripts/basic/fixdep.c:123: error: syntax error before "char"
> scripts/basic/fixdep.c: In function `usage':
> scripts/basic/fixdep.c:129: warning: implicit declaration of function 
> `fprintf'
> scripts/basic/fixdep.c:129: error: `stderr' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:129: error: (Each undeclared identifier is reported 
> only once
> scripts/basic/fixdep.c:129: error: for each function it appears in.)
> scripts/basic/fixdep.c:130: warning: implicit declaration of function `exit'
> scripts/basic/fixdep.c: In function `print_cmdline':
> scripts/basic/fixdep.c:138: warning: implicit declaration of function 
> `printf'
> scripts/basic/fixdep.c: In function `grow_config':
> scripts/basic/fixdep.c:154: warning: implicit declaration of function 
> `realloc'
> scripts/basic/fixdep.c:154: warning: assignment makes pointer from integer 
> without a cast
> scripts/basic/fixdep.c:156: warning: implicit declaration of function 
> `perror'
> scripts/basic/fixdep.c: In function `is_defined_config':
> scripts/basic/fixdep.c:172: warning: implicit declaration of function 
> `memcmp'
> scripts/basic/fixdep.c: In function `define_config':
> scripts/basic/fixdep.c:185: warning: implicit declaration of function 
> `memcpy'
> scripts/basic/fixdep.c: In function `use_config':
> scripts/basic/fixdep.c:204: error: `PATH_MAX' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:218: warning: implicit declaration of function 
> `tolower'
> scripts/basic/fixdep.c:204: warning: unused variable `s'
> scripts/basic/fixdep.c: In function `parse_config_file':
> scripts/basic/fixdep.c:242: warning: implicit declaration of function 
> `isalnum'
> scripts/basic/fixdep.c: In function `strrcmp':
> scripts/basic/fixdep.c:259: warning: implicit declaration of function 
> `strlen'
> scripts/basic/fixdep.c: In function `do_config_file':
> scripts/basic/fixdep.c:274: warning: implicit declaration of function `open'
> scripts/basic/fixdep.c:274: error: `O_RDONLY' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:276: error: `stderr' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:280: warning: implicit declaration of function `fstat'
> scripts/basic/fixdep.c:282: warning: implicit declaration of function `close'
> scripts/basic/fixdep.c:285: warning: implicit declaration of function `mmap'
> scripts/basic/fixdep.c:285: warning: assignment makes pointer from integer 
> without a cast
> scripts/basic/fixdep.c:294: warning: implicit declaration of function 
> `munmap'
> scripts/basic/fixdep.c: In function `parse_dep_file':
> scripts/basic/fixdep.c:304: error: `PATH_MAX' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:306: warning: implicit declaration of function 
> `strchr'
> scripts/basic/fixdep.c:308: error: `stderr' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:304: warning: unused variable `s'
> scripts/basic/fixdep.c: In function `print_deps':
> scripts/basic/fixdep.c:345: error: `O_RDONLY' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:347: error: `stderr' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c:357: warning: assignment makes pointer from integer 
> without a cast
> scripts/basic/fixdep.c: In function `traps':
> scripts/basic/fixdep.c:377: error: `stderr' undeclared (first use in this 
> function)
> scripts/basic/fixdep.c: At top level:
> /usr/include/netinet/in.h:223: error: storage size of `sin_addr' isn't known
> /usr/include/netinet/in.h:238: error: storage size of `sin6_addr' isn't known
> /usr/include/netinet/in.h:314: error: storage size of `imsf_slist' isn't 
> known
> make[1]: *** [scripts/basic/fixdep] Error 1
> make: *** [scripts_basic] Error 2
>
>

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
