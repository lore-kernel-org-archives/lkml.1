Return-Path: <linux-kernel-owner+w=401wt.eu-S1161158AbXDWSBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbXDWSBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161175AbXDWSBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:01:10 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:11703 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161158AbXDWSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:01:09 -0400
Message-ID: <462CF462.10907@interia.pl>
Date: Mon, 23 Apr 2007 20:01:06 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Issue with rdmsr_on_cpu
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: 3757aacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Some time ago I have written hwmon driver for Centaur C7 
processors. Nobody was interested in testing it, so it 
spend long time on my harddisk. Recently one person wanted 
to test it with 2.6.21-rc7. Unfortunatly compile fails. 
I don't understand why. I'm not using rdmsr_on_cpu 
functions. Code is assuming that only one CPU is present 
and using rdmsr function direcly. Is this no longer 
possible? Do I have to #include something? Build log attached. 
I'm not attaching code because error isn't reported in my 
source file, but in Linux includes. My compiler is GCC 4.1.2 
and kernel isn't SMP.

Please CC me.

Thanks
Rafał

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC [M]  drivers/hwmon/c7temp.o
In file included from drivers/hwmon/c7temp.c:19:
include/asm/msr.h:90: error: expected declaration specifiers or '...' before 'u32'
include/asm/msr.h:90: error: expected declaration specifiers or '...' before 'u32'
include/asm/msr.h:90: error: expected declaration specifiers or '...' before 'u32'
include/asm/msr.h: In function 'rdmsr_on_cpu':
include/asm/msr.h:92: error: 'l' undeclared (first use in this function)
include/asm/msr.h:92: error: (Each undeclared identifier is reported only once
include/asm/msr.h:92: error: for each function it appears in.)
include/asm/msr.h:92: error: 'h' undeclared (first use in this function)
include/asm/msr.h:92: error: 'msr_no' undeclared (first use in this function)
include/asm/msr.h:92: error: invalid lvalue in asm output 0
include/asm/msr.h:92: error: invalid lvalue in asm output 1
include/asm/msr.h: At top level:
include/asm/msr.h:94: error: expected declaration specifiers or '...' before 'u32'
include/asm/msr.h:94: error: expected declaration specifiers or '...' before 'u32'
include/asm/msr.h:94: error: expected declaration specifiers or '...' before 'u32'
include/asm/msr.h: In function 'wrmsr_on_cpu':
include/asm/msr.h:96: error: 'msr_no' undeclared (first use in this function)
include/asm/msr.h:96: error: 'l' undeclared (first use in this function)
include/asm/msr.h:96: error: 'h' undeclared (first use in this function)
[...]
make[2]: *** [drivers/hwmon/c7temp.o] Błąd 1
make[1]: *** [drivers/hwmon] Błąd 2
make: *** [drivers] Błąd 2



----------------------------------------------------------------------
Kasia Cichopek eksponuje biust  
>>> http://link.interia.pl/f1a6f

