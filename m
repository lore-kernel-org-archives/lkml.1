Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbXCJMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbXCJMRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 07:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbXCJMRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 07:17:17 -0500
Received: from webmail15.mail.yandex.net ([213.180.200.30]:36708 "EHLO
	webmail15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbXCJMRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 07:17:15 -0500
Date: Sat, 10 Mar 2007 15:16:53 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45F2A1B5.000006.27583@webmail15.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Problem: cat < /dev/my_ttyS0 is not blocked
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.231.74
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem with  cat < /dev/my_ttyS0 (see strace output below). cat function is not blocked. I don't understand why it is not stopped at read(0, __  and terminated?
Thank you

------------------------------------------------------------------------------ 
execve("/bin/cat", ["cat"], [/* 12 vars */]) = 0
brk(0)                                  = 0x7d000
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=5664, ...}) = 0
old_mmap(NULL, 5664, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40017000
close(3)                                = 0
open("/lib/libm.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\250B\0\000"..., 512) = 
512
fstat64(3, {st_mode=S_IFREG|0755, st_size=480324, ...}) = 0
old_mmap(NULL, 506412, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40020000
mprotect(0x40093000, 35372, PROT_NONE)  = 0
old_mmap(0x40098000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 
0x70000) = 0x40098000
close(3)                                = 0
open("/lib/libcrypt.so.1", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\260\10\0"..., 512) = 
512
fstat64(3, {st_mode=S_IFREG|0755, st_size=19940, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 
0x40019000
old_mmap(NULL, 211220, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4009c000
mprotect(0x400a1000, 190740, PROT_NONE) = 0
old_mmap(0x400a4000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0) 
= 0x400a4000
old_mmap(0x400a9000, 157972, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_ANONYMOUS, -1, 0) = 0x400a9000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\330p\1\000"..., 512) = 
512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1240024, ...}) = 0
old_mmap(NULL, 1257088, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x400d0000
mprotect(0x401f5000, 56960, PROT_NONE)  = 0
old_mmap(0x401f8000, 36864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 
0x120000) = 0x401f8000
old_mmap(0x40201000, 7808, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_ANONYMOUS, -1, 0) = 0x40201000
close(3)                                = 0
munmap(0x40017000, 5664)                = 0
getuid32()                              = 0
getgid32()                              = 0
setgid32(0)                             = 0
setuid32(0)                             = 0
read(0, "", 8192)                       = 0
io_submit(0, 0x40200164, 0 <unfinished ... exit status 0>
Process 1653 detached
