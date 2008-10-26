Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYJZNAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYJZNAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYJZNAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:00:08 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:55187 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbYJZNAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:00:06 -0400
Message-ID: <49046872.20300@blueyonder.co.uk>
Date: Sun, 26 Oct 2008 12:54:10 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Random problems with 2.6.28-rc1-git1
References: <49038555.4010507@blueyonder.co.uk> <Pine.LNX.4.64.0810260241290.22126@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0810260241290.22126@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Sat, 25 Oct 2008, Sid Boyce wrote:
>
>> Thunderbird crashes out for me, no problems with 2.6.27-git10. I didn't
>> try 2.6.28-rc1.
>
> Does strace output of thunderbird start reveal any obvious reason for the
> crash on current git tree?
>
I had a look through it yesterday, but found nothing obvious. Here is 
just a part of the strace I saved "strace -s 256 -f thunderbird -o 
TB.out". The crash offers quit or restart thunderbird - crash happens 
again for restart.

[pid  8039] munmap(0xf7f4e000, 338187)  = 0
[pid  8039] set_tid_address(0xf6ed5798) = 8039
[pid  8039] set_robust_list(0xf6ed57a0, 0xc) = 0
[pid  8039] futex(0xffcbd300, FUTEX_WAKE_PRIVATE, 1) = 0
[pid  8039] rt_sigaction(SIGRTMIN, {0x4f7f3a310, [], 
SA_RESTORER|SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_RESETHAND|0x3fbd0a0, 
(nil)}, NULL, 8
) = 0
[pid  8039] rt_sigaction(SIGRT_1, {0x10000004f7f3a750, [], 
SA_RESTORER|SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_RESETHAND|0x3fbd0a0, 
(nil)}, N
ULL, 8) = 0
[pid  8039] rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
[pid  8039] getrlimit(RLIMIT_STACK, {rlim_cur=-4286578688, rlim_max=16}) = 0
[pid  8039] uname({sys="Linux", node="tindog", ...}) = 0
[pid  8039] brk(0)                      = 0x8bc0000
[pid  8039] brk(0x8be1000)              = 0x8be1000
[pid  8039] open("/etc/selinux/config", O_RDONLY|O_LARGEFILE) = -1 
ENOENT (No such file or directory)
[pid  8039] statfs64("/selinux", 84, {???}) = -1 ENOENT (No such file or 
directory)
[pid  8039] open("/proc/mounts", O_RDONLY|O_LARGEFILE) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
[pid  8039] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7fa0000
[pid  8039] read(5, "rootfs / rootfs rw 0 0\nudev /dev tmpfs rw,mode=755 
0 0\n/dev/sda1 / xfs rw,attr2,noquota 0 0\n/proc /proc proc rw 0 0
\nsysfs /sys sysfs rw 0 0\ndebugfs /sys/kernel/debug debugfs rw 0 
0\ndevpts /dev/pts devpts rw,gid=5,mode=620 0 0\n/dev/sdb1 /home/lancelot
/ftp re"..., 1024) = 488
[pid  8039] read(5, ""..., 1024)        = 0
[pid  8039] close(5)                    = 0
[pid  8039] munmap(0xf7fa0000, 4096)    = 0
[pid  8039] futex(0xf7de006c, FUTEX_WAKE_PRIVATE, 2147483647) = 0
[pid  8039] sched_get_priority_min(SCHED_OTHER) = 0
[pid  8039] sched_get_priority_max(SCHED_OTHER) = 0
[pid  8039] sched_getparam(8039, { 0 }) = 0
[pid  8039] sched_getscheduler(8039)    = 0 (SCHED_OTHER)
[pid  8039] sched_setscheduler(8039, SCHED_OTHER, { 0 }) = 0
[pid  8039] rt_sigaction(SIGPIPE, {0x1, [], 
SA_RESTORER|SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_RESETHAND|0x3e1a580, 
(nil)}, NULL, 8) = 0
[pid  8039] gettimeofday({1224966670, 772221}, NULL) = 0
[pid  8039] time(NULL)                  = 1224966670
[pid  8039] lstat64("/usr", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid  8039] lstat64("/usr/local", {st_mode=S_IFDIR|0755, st_size=4096, 
...}) = 0
[pid  8039] lstat64("/usr/local/thunderbird", {st_mode=S_IFDIR|0755, 
st_size=4096, ...}) = 0
[pid  8039] lstat64("/usr/local/thunderbird/thunderbird-bin", 
{st_mode=S_IFREG|0755, st_size=12034244, ...}) = 0
[pid  8039] stat64("/usr/local/thunderbird/thunderbird-bin", 
{st_mode=S_IFREG|0755, st_size=12034244, ...}) = 0
[pid  8039] open("/usr/local/thunderbird/application.ini", O_RDONLY) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=2020, ...}) = 0
[pid  8039] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7fa0000
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=2020, ...}) = 0
[pid  8039] _llseek(5, 0, [0], SEEK_SET) = 0
[pid  8039] read(5, "; ***** BEGIN LICENSE BLOCK *****\n; Version: MPL 
1.1/GPL 2.0/LGPL 2.1\n;\n; The contents of this file are subject to
the Mozilla Public License Version\n; 1.1 (the \"License\"); you may not 
use this file except in compliance with\n; the License. You may ob
tain a "..., 2020) = 2020
[pid  8039] _llseek(5, 2020, [2020], SEEK_SET) = 0
[pid  8039] close(5)                    = 0
[pid  8039] munmap(0xf7fa0000, 4096)    = 0
[pid  8039] lstat64("/usr", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
[pid  8039] lstat64("/usr/local", {st_mode=S_IFDIR|0755, st_size=4096, 
...}) = 0
[pid  8039] lstat64("/usr/local/thunderbird", {st_mode=S_IFDIR|0755, 
st_size=4096, ...}) = 0
[pid  8039] lstat64("/usr/local/thunderbird/thunderbird-bin", 
{st_mode=S_IFREG|0755, st_size=12034244, ...}) = 0
[pid  8039] stat64("/usr/local/thunderbird/thunderbird-bin", 
{st_mode=S_IFREG|0755, st_size=12034244, ...}) = 0
[pid  8039] open("/usr/local/thunderbird/platform.ini", O_RDONLY) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=44, ...}) = 0
[pid  8039] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7fa0000
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=44, ...}) = 0
[pid  8039] _llseek(5, 0, [0], SEEK_SET) = 0
[pid  8039] read(5, 
"[Build]\nBuildID=2008050714\nMilestone=1.9pre\n"..., 44) = 44
[pid  8039] _llseek(5, 44, [44], SEEK_SET) = 0
[pid  8039] close(5)                    = 0
[pid  8039] munmap(0xf7fa0000, 4096)    = 0
[pid  8039] mmap2(NULL, 1052672, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff6dd4000
[pid  8039] sigaltstack({ss_sp=0x8bc3448, ss_flags=0x800 /* SS_??? */, 
ss_size=629063072349956424}, NULL) = 0
[pid  8039] rt_sigaction(SIGSEGV, {0x800000008083744, [RT_21], 
SA_RESTORER|SA_STACK|SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_RESETHAND|0x3cbd2
a8, (nil)}, {SIG_DFL, ~[INT QUIT TRAP BUS FPE SEGV TERM CHLD STOP WINCH 
RT_1 RT_2 RT_4 RT_5 RT_8 RT_9 RT_11 RT_13 RT_14 RT_19 RT_21 RT_22],
  SA_STACK|SA_RESTART|0x30907c0}, 8) = 0
[pid  8039] rt_sigaction(SIGABRT, {0x800000008083744, [RT_21], 
SA_STACK|SA_SIGINFO|0xbc2960}, {SIG_DFL, ~[HUP INT QUIT ILL TRAP KILL USR1 U
SR2 PIPE STKFLT STOP WINCH RT_1 RT_2 RT_3 RT_5 RT_8 RT_10 RT_11 RT_13 
RT_15 RT_16 RT_17 RT_18 RT_23 RT_25 RT_26 RT_27 RT_29 RT_30 RT_31], S
A_STACK|SA_RESTART|0x30907c0}, 8) = 0
[pid  8039] rt_sigaction(SIGFPE, {0x800000008083744, [RT_21], 
SA_RESTORER|SA_STACK|SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_RESETHAND|0x3cbca7
0, (nil)}, {SIG_DFL, ~[HUP INT QUIT ILL TRAP KILL USR1 USR2 PIPE STKFLT 
STOP WINCH RT_1 RT_2 RT_3 RT_5 RT_8 RT_10 RT_11 RT_13 RT_15 RT_16 R
T_17 RT_18 RT_23 RT_25 RT_26 RT_27 RT_29 RT_30 RT_31], 
SA_STACK|SA_RESTART|0x30907c0}, 8) = 0
[pid  8039] rt_sigaction(SIGILL, {0x800000008083744, [RT_21], 
SA_RESTORER|SA_STACK|SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_RESETHAND|SA_SIGIN
FO|0x3cbca68, (nil)}, {SIG_DFL, ~[HUP INT ILL PIPE ALRM STKFLT STOP TSTP 
URG XCPU WINCH RT_1 RT_2 RT_3 RT_4 RT_9 RT_10 RT_11 RT_13 RT_15 RT
_16 RT_17 RT_18 RT_23 RT_25 RT_26 RT_27 RT_29 RT_30 RT_31], 
SA_STACK|SA_RESTART|0x30907c0}, 8) = 0
[pid  8039] rt_sigaction(SIGBUS, {0x800000008083744, [RT_21], 
SA_RESTORER|SA_STACK|SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_RESETHAND|0x3cbca7
0, (nil)}, {SIG_DFL, ~[HUP INT ILL PIPE ALRM STKFLT STOP TSTP URG XCPU 
WINCH RT_1 RT_2 RT_3 RT_4 RT_9 RT_10 RT_11 RT_13 RT_15 RT_16 RT_17 R
T_18 RT_23 RT_25 RT_26 RT_27 RT_29 RT_30 RT_31], 
SA_STACK|SA_RESTART|0x30907c0}, 8) = 0
[pid  8039] time(NULL)                  = 1224966670
[pid  8039] access("/home/lancelot/.thunderbird", F_OK) = 0
[pid  8039] access("/home/lancelot/.thunderbird/Crash Reports", F_OK) = 0
[pid  8039] access("/home/lancelot/.thunderbird/Crash Reports/UserID", 
F_OK) = 0
[pid  8039] open("/home/lancelot/.thunderbird/Crash Reports/UserID", 
O_RDONLY|O_LARGEFILE) = 5
[pid  8039] lseek(5, 0, SEEK_CUR)       = 0
[pid  8039] lseek(5, 0, SEEK_END)       = 36
[pid  8039] lseek(5, 0, SEEK_SET)       = 0
[pid  8039] read(5, "244016cc-9f2a-f1da-704b-2759d2908d01"..., 36) = 36
[pid  8039] close(5)                    = 0
[pid  8039] access("/home/lancelot/.thunderbird/Crash 
Reports/InstallTime2008050714", F_OK) = 0
[pid  8039] open("/home/lancelot/.thunderbird/Crash 
Reports/InstallTime2008050714", O_RDONLY|O_LARGEFILE) = 5
[pid  8039] lseek(5, 0, SEEK_CUR)       = 0
[pid  8039] lseek(5, 0, SEEK_END)       = 10
[pid  8039] lseek(5, 0, SEEK_SET)       = 0
[pid  8039] read(5, "1210890528"..., 10) = 10
[pid  8039] close(5)                    = 0
[pid  8039] access("/home/lancelot/.thunderbird/Crash 
Reports/LastCrash", F_OK) = 0
[pid  8039] open("/home/lancelot/.thunderbird/Crash Reports/LastCrash", 
O_RDONLY|O_LARGEFILE) = 5
[pid  8039] lseek(5, 0, SEEK_CUR)       = 0
[pid  8039] lseek(5, 0, SEEK_END)       = 10
[pid  8039] lseek(5, 0, SEEK_SET)       = 0
[pid  8039] read(5, "1224966311"..., 10) = 10
[pid  8039] close(5)                    = 0
[pid  8039] access("/usr/local/thunderbird/crashreporter-override.ini", 
F_OK) = -1 ENOENT (No such file or directory)
[pid  8039] clock_getres(CLOCK_MONOTONIC, {0, 1}) = 0
[pid  8039] sched_get_priority_min(SCHED_OTHER) = 0
[pid  8039] sched_get_priority_max(SCHED_OTHER) = 0
[pid  8039] sched_get_priority_max(SCHED_OTHER) = 0
[pid  8039] gettimeofday({1224966670, 781495}, NULL) = 0
[pid  8039] open("/usr/lib/charset.alias", O_RDONLY|O_LARGEFILE) = -1 
ENOENT (No such file or directory)
[pid  8039] open("/usr/share/locale/locale.alias", O_RDONLY|O_LARGEFILE) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=2512, ...}) = 0
[pid  8039] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7fa0000
[pid  8039] read(5, "# Locale name alias data base.\n# Copyright (C) 
1996-2001,2003,2007 Free Software Foundation, Inc.\n#\n# This program
is free software; you can redistribute it and/or modify\n# it under the 
terms of the GNU General Public License as published by\n# the Free
  Soft"..., 4096) = 2512
[pid  8039] read(5, ""..., 4096)        = 0
[pid  8039] close(5)                    = 0
[pid  8039] munmap(0xf7fa0000, 4096)    = 0
[pid  8039] open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) 
= -1 ENOENT (No such file or directory)
[pid  8039] open("/usr/share/locale/locale.alias", O_RDONLY) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=2512, ...}) = 0
[pid  8039] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7fa0000
[pid  8039] read(5, "# Locale name alias data base.\n# Copyright (C) 
1996-2001,2003,2007 Free Software Foundation, Inc.\n#\n# This program
is free software; you can redistribute it and/or modify\n# it under the 
terms of the GNU General Public License as published by\n# the Free
  Soft"..., 4096) = 2512
[pid  8039] read(5, ""..., 4096)        = 0
[pid  8039] close(5)                    = 0
[pid  8039] munmap(0xf7fa0000, 4096)    = 0
[pid  8039] open("/usr/lib/locale/en_GB.UTF-8/LC_IDENTIFICATION", 
O_RDONLY) = -1 ENOENT (No such file or directory)
[pid  8039] open("/usr/lib/locale/en_GB.utf8/LC_IDENTIFICATION", 
O_RDONLY) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=366, ...}) = 0
[pid  8039] mmap2(NULL, 366, PROT_READ, MAP_PRIVATE, 5, 0) = 
0xfffffffff7fa0000
[pid  8039] close(5)                    = 0
[pid  8039] open("/usr/lib/gconv/gconv-modules.cache", O_RDONLY) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=26040, ...}) = 0
[pid  8039] mmap2(NULL, 26040, PROT_READ, MAP_SHARED, 5, 0) = 
0xfffffffff7f99000
[pid  8039] close(5)                    = 0
[pid  8039] futex(0xf7238a4c, FUTEX_WAKE_PRIVATE, 2147483647) = 0
[pid  8039] open("/usr/lib/locale/en_GB.UTF-8/LC_MEASUREMENT", O_RDONLY) 
= -1 ENOENT (No such file or directory)
[pid  8039] open("/usr/lib/locale/en_GB.utf8/LC_MEASUREMENT", O_RDONLY) = 5
[pid  8039] fstat64(5, {st_mode=S_IFREG|0644, st_size=23, ...}) = 0
[pid  8039] mmap2(NULL, 23, PROT_READ, MAP_PRIVATE, 5, 0) = 
0xfffffffff7f98000
[pid  8039] close(5)                    = 0

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

