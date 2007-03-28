Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXC1PfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXC1PfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXC1PfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:35:18 -0400
Received: from bay0-omc1-s19.bay0.hotmail.com ([65.54.246.91]:33152 "EHLO
	bay0-omc1-s19.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbXC1PfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:35:16 -0400
Message-ID: <BAY103-DAV13FD7B01A80319110AFA3BB26D0@phx.gbl>
X-Originating-IP: [85.36.106.214]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: oracle sqlplus loop on 2.6.20
Date: Wed, 28 Mar 2007 17:34:23 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 28 Mar 2007 15:35:15.0527 (UTC) FILETIME=[AEAC6570:01C7714E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody.
I'm running oracle 10.2.0.1 on Slackware Linux 10.2
After 50 days uptime, sqlplus was looping forever.
I have killed all oracle processes and cleared all
semaphore and shared memory segment with ipcrm.
I have also unmounted & remounted the file system
where the oracle binaries and library resides,
but no luck. I have to do a shutdown.
This is the output from 'strace sqlplus'.
Any hint?

TIA

execve("/u01/app/oracle/product/10.2.0.1/bin/sqlplus", ["sqlplus"], [/*
39 vars */]) = 0
uname({sys="Linux", node="Tethys", ...}) = 0
brk(0)                                  = 0x804a000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
open("/u01/app/oracle/product/10.2.0.1/lib/tls/i686/sse2/libsqlplus.so",
O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/u01/app/oracle/product/10.2.0.1/lib/tls/i686/sse2", 0xbfaed0c0)
= -1 ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/tls/i686/libsqlplus.so",
O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/u01/app/oracle/product/10.2.0.1/lib/tls/i686", 0xbfaed0c0) = -1
ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/tls/sse2/libsqlplus.so",
O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/u01/app/oracle/product/10.2.0.1/lib/tls/sse2", 0xbfaed0c0) = -1
ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/tls/libsqlplus.so", O_RDONLY)
= -1 ENOENT (No such file or directory)
stat64("/u01/app/oracle/product/10.2.0.1/lib/tls", 0xbfaed0c0) = -1
ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/i686/sse2/libsqlplus.so",
O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/u01/app/oracle/product/10.2.0.1/lib/i686/sse2", 0xbfaed0c0)
= -1 ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/i686/libsqlplus.so",
O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/u01/app/oracle/product/10.2.0.1/lib/i686", 0xbfaed0c0) = -1
ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/sse2/libsqlplus.so",
O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/u01/app/oracle/product/10.2.0.1/lib/sse2", 0xbfaed0c0) = -1
ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/libsqlplus.so", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@H\1\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0640, st_size=1047293, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7fe4000
mmap2(NULL, 728168, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7f32000
mmap2(0xb7fdb000, 36864, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xa8) = 0xb7fdb000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libclntsh.so.10.1", O_RDONLY)
= 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\306"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0750, st_size=18440031, ...}) = 0
mmap2(NULL, 14298152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb718f000
mmap2(0xb7ebd000, 397312, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd2e) = 0xb7ebd000
mmap2(0xb7f1e000, 80936, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f1e000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libnnz10.so", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3006\6"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0640, st_size=5480533, ...}) = 0
mmap2(NULL, 2110644, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb6f8b000
mmap2(0xb7167000, 155648, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1dc) = 0xb7167000
mmap2(0xb718d000, 5300, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb718d000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libdl.so.2", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=53426, ...}) = 0
mmap2(NULL, 53426, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f7d000
close(3)                                = 0
open("/lib/tls/libdl.so.2", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\300\v\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=13120, ...}) = 0
mmap2(NULL, 12392, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)
= 0xb6f79000
mmap2(0xb6f7b000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb6f7b000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libm.so.6", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/lib/tls/libm.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P3\0\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=176352, ...}) = 0
mmap2(NULL, 139424, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb6f56000
mmap2(0xb6f77000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20) = 0xb6f77000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libpthread.so.0", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/lib/tls/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0000H\0\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=87827, ...}) = 0
mmap2(NULL, 70104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)
= 0xb6f44000
mmap2(0xb6f52000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd) = 0xb6f52000
mmap2(0xb6f54000, 4568, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f54000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libnsl.so.1", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/lib/tls/libnsl.so.1", O_RDONLY)  = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 5\0\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=92501, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6f43000
mmap2(NULL, 88064, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)
= 0xb6f2d000
mmap2(0xb6f3f000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x11) = 0xb6f3f000
mmap2(0xb6f41000, 6144, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f41000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libc.so.6", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\300P\1"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1366940, ...}) = 0
mmap2(NULL, 1162428, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb6e11000
mprotect(0xb6f26000, 27836, PROT_NONE)  = 0
mmap2(0xb6f27000, 16384, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x115) = 0xb6f27000
mmap2(0xb6f2b000, 7356, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f2b000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6e10000
mprotect(0xb6f27000, 4096, PROT_READ)   = 0
mprotect(0xb6f8b000, 1949696, PROT_READ|PROT_WRITE) = 0
mprotect(0xb6f8b000, 1949696, PROT_READ|PROT_EXEC) = 0
mprotect(0xb718f000, 13819904, PROT_READ|PROT_WRITE) = 0
mprotect(0xb718f000, 13819904, PROT_READ|PROT_EXEC) = 0
mprotect(0xb7f32000, 692224, PROT_READ|PROT_WRITE) = 0
mprotect(0xb7f32000, 692224, PROT_READ|PROT_EXEC) = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb6e106c0,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb6f7d000, 53426)               = 0
set_tid_address(0xb6e10708)             = 14544
rt_sigaction(SIGRTMIN, {0xb6f48700, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb6f48780, [], SA_RESTART|SA_SIGINFO}, NULL, 8)
= 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) =
0
_sysctl({{CTL_KERN, KERN_VERSION}, 2, 0xbfaed630, 34, (nil), 0}) = 0
brk(0)                                  = 0x804a000
brk(0x806b000)                          = 0x806b000
mmap2(NULL, 143360, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6ded000
futex(0xb6f7c064, FUTEX_WAKE, 2147483647) = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libsqlplusic.so", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/libsqlplusic.so", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/libsqlplusic.so", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=53426, ...}) = 0
mmap2(NULL, 53426, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f7d000
close(3)                                = 0
open("/lib/tls/i686/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No
such file or directory)
stat64("/lib/tls/i686/sse2", 0xbfaeb164) = -1 ENOENT (No such file or
directory)
open("/lib/tls/i686/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/lib/tls/i686", 0xbfaeb164)     = -1 ENOENT (No such file or
directory)
open("/lib/tls/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/lib/tls/sse2", 0xbfaeb164)     = -1 ENOENT (No such file or
directory)
open("/lib/tls/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/tls", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/lib/i686/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/lib/i686/sse2", 0xbfaeb164)    = -1 ENOENT (No such file or
directory)
open("/lib/i686/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/i686", 0xbfaeb164)         = -1 ENOENT (No such file or
directory)
open("/lib/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such file or
 directory)
stat64("/lib/sse2", 0xbfaeb164)         = -1 ENOENT (No such file or
directory)
open("/lib/libsqlplusic.so", O_RDONLY)  = -1 ENOENT (No such file or
directory)
stat64("/lib", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/usr/lib/tls/i686/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No
such file or directory)
stat64("/usr/lib/tls/i686/sse2", 0xbfaeb164) = -1 ENOENT (No such file
or directory)
open("/usr/lib/tls/i686/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/usr/lib/tls/i686", 0xbfaeb164) = -1 ENOENT (No such file or
directory)
open("/usr/lib/tls/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/usr/lib/tls/sse2", 0xbfaeb164) = -1 ENOENT (No such file or
directory)
open("/usr/lib/tls/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such file
or directory)
stat64("/usr/lib/tls", 0xbfaeb164)      = -1 ENOENT (No such file or
directory)
open("/usr/lib/i686/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No
such file or directory)
stat64("/usr/lib/i686/sse2", 0xbfaeb164) = -1 ENOENT (No such file or
directory)
open("/usr/lib/i686/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/usr/lib/i686", 0xbfaeb164)     = -1 ENOENT (No such file or
directory)
open("/usr/lib/sse2/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/usr/lib/sse2", 0xbfaeb164)     = -1 ENOENT (No such file or
directory)
open("/usr/lib/libsqlplusic.so", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/usr/lib", {st_mode=S_IFDIR|0755, st_size=24576, ...}) = 0
munmap(0xb6f7d000, 53426)               = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libociicus.so", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/libociicus.so", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/libociicus.so", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=53426, ...}) = 0
mmap2(NULL, 53426, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f7d000
close(3)                                = 0
open("/lib/tls/libociicus.so", O_RDONLY) = -1 ENOENT (No such file or
directory)
open("/lib/libociicus.so", O_RDONLY)    = -1 ENOENT (No such file or
directory)
open("/usr/lib/libociicus.so", O_RDONLY) = -1 ENOENT (No such file or
directory)
munmap(0xb6f7d000, 53426)               = 0
open("/u01/app/oracle/product/10.2.0.1/lib/libociei.so", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/libociei.so", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/u01/app/oracle/product/10.2.0.1/lib/libociei.so", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=53426, ...}) = 0
mmap2(NULL, 53426, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f7d000
close(3)                                = 0
open("/lib/tls/libociei.so", O_RDONLY)  = -1 ENOENT (No such file or
directory)
open("/lib/libociei.so", O_RDONLY)      = -1 ENOENT (No such file or
directory)
open("/usr/lib/libociei.so", O_RDONLY)  = -1 ENOENT (No such file or
directory)
munmap(0xb6f7d000, 53426)               = 0
open("/u01/app/oracle/product/10.2.0.1/nls/data/lx1boot.nlb", O_RDONLY)
= 3
read(3, "\0\0\0\3\0\1 \n\300V\0\0 \257\215\0\0\0\0\0\1\0B\0\271"..., 48)
= 48
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
22160) = 22160
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/nls/data/lx00001.nlb", O_RDONLY)
= 3
read(3, "\0\0\0\3\0\1 \n\263\3\0\0o\2\0\0\0\0\0\0\0\0\0\0\0Z\1\0"...,
92) = 92
read(3, "\3\0\0\0\1\0\1\0\1\0`\0\0\0\0\0\2\0\4\0\6\0\f\0\24\0\34"...,
856) = 855
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/nls/data/lx2002e.nlb", O_RDONLY)
= 3
read(3, "\0\0\0\3\0\1 \n\372\30\0\0N\17\0\0\0\0\0\0\2\0\0\0\0Z\1"...,
92) = 92
read(3, ".\0.\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0\277\0\0\0\0\1\0\0\0"...,
6304) = 6302
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/nls/data/lx10001.nlb", O_RDONLY)
= 3
read(3, "\0\0\0\3\0\1 \np\4\0\0\214\3\0\0\0\0\0\0\1\0\0\0\0Z\1\0"...,
92) = 92
read(3, "\3\0\0\0\1\0\1\0\0\0\0\0\0\0\4\0\1\0\2\0\2\0\1\0\1\0\0"...,
1044) = 1044
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/nls/data/lx20001.nlb", O_RDONLY)
= 3
read(3, "\0\0\0\3\0\1 \n5\33\0\0\211\21\0\0\0\0\0\0\2\0\0\0\0Z\1"...,
92) = 92
read(3, "\1\0\37\0\t\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\1\0\0\0"...,
6876) = 6873
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/nls/data/lx40001.nlb", O_RDONLY)
= 3
read(3, "\0\0\0\3\0\1 \n\\}\0\0008|\0\0\0\0\0\0\4\0\0\0\0Z\1\0\0"...,
92) = 92
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\264O\0\0\20[\0\0\314\\\0\0\330"...,
32000) = 32000
close(3)                                = 0
open("/u01/app/oracle/product/10.2.0.1/sqlplus/mesg/sp1us.msb",
O_RDONLY) = 3
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
lseek(3, 0, SEEK_SET)                   = 0
read(3, "\25\23\"\1\23\3\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
256) = 256
open("/u01/app/oracle/product/10.2.0.1/sqlplus/mesg/sp2us.msb",
O_RDONLY) = 4
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
lseek(4, 0, SEEK_SET)                   = 0
read(4, "\25\23\"\1\23\3\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
256) = 256
brk(0x808c000)                          = 0x808c000
open("/u01/app/oracle/product/10.2.0.1/sqlplus/mesg/cpyus.msb",
O_RDONLY) = 5
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
lseek(5, 0, SEEK_SET)                   = 0
read(5, "\25\23\"\1\23\3\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
256) = 256
lseek(5, 512, SEEK_SET)                 = 512
read(5, "\f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
512) = 512
lseek(5, 1024, SEEK_SET)                = 1024
read(5, "\t\0\f\0", 4)                  = 4
gettimeofday({1175076930, 962804}, NULL) = 0
open("/etc/localtime", O_RDONLY)        = 6
fstat64(6, {st_mode=S_IFREG|0644, st_size=951, ...}) = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=951, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6f8a000
read(6, "TZif\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\6\0\0\0\6\0"...,
4096) = 951
close(6)                                = 0
munmap(0xb6f8a000, 4096)                = 0
open("/u01/app/oracle/product/10.2.0.1/oracore/zoneinfo/timezlrg.dat",
O_RDONLY) = 6
fstat64(6, {st_mode=S_IFREG|0640, st_size=384987, ...}) = 0
mmap2(NULL, 384987, PROT_READ, MAP_PRIVATE|MAP_NORESERVE, 6, 0) =
0xb6d8f000
close(6)                                = 0
open("/u01/app/oracle/product/10.2.0.1/oracore/zoneinfo/timezlrg.dat",
O_RDONLY|O_LARGEFILE) = 6
fstat64(6, {st_mode=S_IFREG|0640, st_size=384987, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6f8a000
read(6, "ZTrO\333\337\5\0\2\0\2\0\2\0y\1_=\276\0024\20\0\0\374\33"...,
4096) = 4096
read(6, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
4096) = 4096
close(6)                                = 0
munmap(0xb6f8a000, 4096)                = 0
mmap2(NULL, 385024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6d31000
open("/u01/app/oracle/product/10.2.0.1/oracore/zoneinfo/timezlrg.dat",
O_RDONLY|O_LARGEFILE) = 6
fstat64(6, {st_mode=S_IFREG|0640, st_size=384987, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6d30000
read(6, "ZTrO\333\337\5\0\2\0\2\0\2\0y\1_=\276\0024\20\0\0\374\33"...,
4096) = 4096
read(6, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
4096) = 4096
close(6)                                = 0
munmap(0xb6d30000, 4096)                = 0
open("/u01/app/oracle/product/10.2.0.1/oracore/zoneinfo/timezlrg.dat",
O_RDONLY|O_LARGEFILE) = 6
fstat64(6, {st_mode=S_IFREG|0640, st_size=384987, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6d30000
read(6, "ZTrO\333\337\5\0\2\0\2\0\2\0y\1_=\276\0024\20\0\0\374\33"...,
380928) = 380928
read(6, "GMT-1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Etc/GMT-10\0"..., 4096) =
4059
close(6)                                = 0
munmap(0xb6d30000, 4096)                = 0
gettimeofday({1175076930, 966285}, NULL) = 0
access("/u01/app/oracle/product/10.2.0.1/network/admin/sqlnet.ora",
F_OK) = 0
open("/u01/app/oracle/product/10.2.0.1/network/admin/sqlnet.ora",
O_RDONLY|O_LARGEFILE) = 6
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0660, st_size=251, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6d30000
read(6, "# sqlnet.ora Network Configurati"..., 4096) = 251
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0xb6d30000, 4096)                = 0
access("/u01/app/oracle/product/10.2.0.1/network/admin/sqlnet.ora",
F_OK) = 0
open("/u01/app/oracle/product/10.2.0.1/network/admin/sqlnet.ora",
O_RDONLY|O_LARGEFILE) = 6
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0660, st_size=251, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb6d30000
read(6, "# sqlnet.ora Network Configurati"..., 4096) = 251
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0xb6d30000, 4096)                = 0
open("/u01/app/oracle/product/10.2.0.1/rdbms/mesg/ocius.msb", O_RDONLY)
= 6
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
lseek(6, 0, SEEK_SET)                   = 0
read(6, "\25\23\"\1\23\3\t\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
256) = 256
lseek(6, 512, SEEK_SET)                 = 512
read(6, "\337y\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
512) = 512
lseek(6, 1024, SEEK_SET)                = 1024
read(6, "\25\7\'\0072\7>\7j\7\276\17$\'\6K5S\24TfT\307T(VsV\222"..., 86)
= 86
times(NULL)                             = -2145973996
times(NULL)                             = -2145973996
times(NULL)                             = -2145973996
[...]


