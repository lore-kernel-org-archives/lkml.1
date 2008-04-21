Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbYDUSuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbYDUSuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYDUSt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:49:57 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:43233 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYDUSt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:49:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type;
	b=T/SOogtSVxEsyPh1TWLnIda3HUiur0qtXCItztRy8lwyL526rYYprCuaMntmWBOTOI9R2HGzCJOg4Css2fryGE9Uh1Zp6+Zv3MTsz+M9HeM88A30SywabDQ1uAu10Ej7zL2107WXDm4MNFpvWm3MJzNP2QNtSvy8fM0Fo6224i8=;
Message-ID: <480CE167.8090907@unsolicited.net>
Date: Mon, 21 Apr 2008 19:48:07 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: serge@hallyn.com
CC: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com> <480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com> <20080421080101.htzh4s03snescog4@unsolicited.net> <20080421183451.GA22071@vino.hallyn.com>
In-Reply-To: <20080421183451.GA22071@vino.hallyn.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------010008070904080107000504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010008070904080107000504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

serge@hallyn.com wrote:
>>
>> /lib/libcap.so.1 -> libcap.so.1.92
>>
>> I guess that's 1.92 (should be the version shipped with SuSE 9.1).
>>     
>
> Ok, thanks, then it's definately not what I was thinking.
>
> (Will wait to check out your strace)
>   
strace attached.

Cheers
David


--------------010008070904080107000504
Content-Type: text/plain;
 name="ntp.strace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ntp.strace"

execve("/usr/sbin/ntpd", ["ntpd", "-c", "/etc/ntp.conf", "-i", "/var/lib/ntp/", "-p", "/var/run/ntp/ntpd.pid", "-u", "ntp"], [/* 56 vars */]) = 0
uname({sys="Linux", node="server", ...}) = 0
brk(0)                                  = 0x80f8000
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40017000
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=103028, ...}) = 0
old_mmap(NULL, 103028, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40018000
close(3)                                = 0
open("/lib/tls/libm.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p5\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=170563, ...}) = 0
old_mmap(NULL, 137712, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40032000
madvise(0x40032000, 137712, MADV_SEQUENTIAL|0x1) = 0
old_mmap(0x40053000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x20000) = 0x40053000
close(3)                                = 0
open("/usr/lib/libcrypto.so.0.9.8", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0b\3\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0555, st_size=1417403, ...}) = 0
old_mmap(NULL, 1223928, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40054000
madvise(0x40054000, 1223928, MADV_SEQUENTIAL|0x1) = 0
old_mmap(0x40167000, 86016, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x113000) = 0x40167000
old_mmap(0x4017c000, 11512, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4017c000
close(3)                                = 0
mprotect(0xbf8ab000, 4096, PROT_READ|PROT_WRITE|PROT_EXEC|PROT_GROWSDOWN) = 0
open("/lib/libcap.so.1", O_RDONLY)      = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\16\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=33287, ...}) = 0
old_mmap(NULL, 13520, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4017f000
madvise(0x4017f000, 13520, MADV_SEQUENTIAL|0x1) = 0
old_mmap(0x40182000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x2000) = 0x40182000
close(3)                                = 0
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\360U\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1349081, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40183000
old_mmap(NULL, 1132940, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40184000
madvise(0x40184000, 1132940, MADV_SEQUENTIAL|0x1) = 0
old_mmap(0x4028e000, 32768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x10a000) = 0x4028e000
old_mmap(0x40296000, 10636, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40296000
close(3)                                = 0
open("/lib/libdl.so.2", O_RDONLY)       = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\33\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=13647, ...}) = 0
old_mmap(NULL, 8628, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40299000
madvise(0x40299000, 8628, MADV_SEQUENTIAL|0x1) = 0
old_mmap(0x4029b000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x2000) = 0x4029b000
close(3)                                = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x4029c000
set_thread_area({entry_number:-1 -> 6, base_addr:0x4029c080, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0x40018000, 103028)              = 0
socket(PF_UNIX, SOCK_DGRAM, 0)          = 3
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
connect(3, {sa_family=AF_UNIX, path="/dev/log"}, 16) = 0
brk(0)                                  = 0x80f8000
brk(0x8119000)                          = 0x8119000
brk(0)                                  = 0x8119000
time([1208803493])                      = 1208803493
open("/etc/localtime", O_RDONLY)        = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=1323, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40018000
read(4, "TZif\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\7\0\0\0\7\0"..., 4096) = 1323
close(4)                                = 0
munmap(0x40018000, 4096)                = 0
getpid()                                = 6117
rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_DFL}, 8) = 0
send(3, "<29>Apr 21 19:44:53 ntpd[6117]: "..., 86, 0) = 86
rt_sigaction(SIGPIPE, {SIG_DFL}, NULL, 8) = 0
umask(0)                                = 022
umask(022)                              = 0
getuid32()                              = 0
gettimeofday({1208803493, 60029}, NULL) = 0
clone(Process 6118 attached
child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x4029c0c8) = 6118
[pid  6118] setsid()                    = 6118
[pid  6118] chdir("/")                  = 0
[pid  6118] open("/dev/null", O_RDWR)   = 4
[pid  6118] fstat64(4, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
[pid  6118] dup2(4, 0)                  = 0
[pid  6118] dup2(4, 1)                  = 1
[pid  6118] dup2(4, 2)                  = 2
[pid  6118] close(4)                    = 0
[pid  6118] rt_sigaction(SIGHUP, {0x80540f0, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGINT, {0x80540f0, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGQUIT, {0x80540f0, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGTERM, {0x80540f0, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGBUS, {0x80540f0, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGUSR1, {0x8053670, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGUSR2, {0x8053620, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigaction(SIGALRM, {0x806e540, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] setitimer(ITIMER_REAL, {it_interval={1, 0}, it_value={1, 0}}, NULL) = 0
[pid  6118] uname({sys="Linux", node="server", ...}) = 0
[pid  6118] gettimeofday({1208803493, 62080}, NULL) = 0
[pid  6118] gettimeofday({1208803493, 62142}, NULL) = 0
[pid  6118] gettimeofday({1208803493, 62198}, NULL) = 0
[pid  6118] gettimeofday({1208803493, 62252}, NULL) = 0
[pid  6118] gettimeofday({1208803493, 62305}, NULL) = 0
[pid  6118] gettimeofday({1208803493, 62359}, NULL) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 55, 0) = 55
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] gettimeofday({1208803493, 62944}, NULL) = 0
[pid  6118] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 4
[pid  6118] close(4)                    = 0
[pid  6118] socket(PF_INET6, SOCK_STREAM, IPPROTO_IP) = -1 EAFNOSUPPORT (Address family not supported by protocol)
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 4
[pid  6118] getrlimit(RLIMIT_NOFILE, {rlim_cur=1024, rlim_max=1024}) = 0
[pid  6118] getrlimit(RLIMIT_NOFILE, {rlim_cur=1024, rlim_max=1024}) = 0
[pid  6118] getrlimit(RLIMIT_NOFILE, {rlim_cur=1024, rlim_max=1024}) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<31>Apr 21 19:44:53 ntpd[6118]: "..., 100, 0) = 100
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] fcntl64(4, F_DUPFD, 16)     = 16
[pid  6118] close(4)                    = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] bind(16, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(16, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 88, 0) = 88
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 4
[pid  6118] ioctl(4, 0x8912, 0x80f82b8) = 0
[pid  6118] open("/proc/net/if_inet6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
[pid  6118] fcntl64(5, F_DUPFD, 16)     = 17
[pid  6118] close(5)                    = 0
[pid  6118] setsockopt(17, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] bind(17, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("127.0.0.1")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(17, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(17, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 83, 0) = 83
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
[pid  6118] fcntl64(5, F_DUPFD, 16)     = 18
[pid  6118] close(5)                    = 0
[pid  6118] setsockopt(18, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] bind(18, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("192.168.0.39")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(18, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(18, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 88, 0) = 88
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
[pid  6118] fcntl64(5, F_DUPFD, 16)     = 19
[pid  6118] close(5)                    = 0
[pid  6118] setsockopt(19, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] bind(19, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("192.168.2.2")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(19, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(19, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 87, 0) = 87
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
[pid  6118] fcntl64(5, F_DUPFD, 16)     = 20
[pid  6118] close(5)                    = 0
[pid  6118] setsockopt(20, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] bind(20, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("192.168.0.65")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(20, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(20, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 88, 0) = 88
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
[pid  6118] fcntl64(5, F_DUPFD, 16)     = 21
[pid  6118] close(5)                    = 0
[pid  6118] setsockopt(21, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] bind(21, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("192.168.0.1")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(21, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(21, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 87, 0) = 87
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
[pid  6118] fcntl64(5, F_DUPFD, 16)     = 22
[pid  6118] close(5)                    = 0
[pid  6118] setsockopt(22, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] bind(22, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("192.168.10.1")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(22, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(22, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 91, 0) = 91
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
[pid  6118] fcntl64(5, F_DUPFD, 16)     = 23
[pid  6118] close(5)                    = 0
[pid  6118] setsockopt(23, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
[pid  6118] bind(23, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("192.168.20.1")}, 16) = 0
[pid  6118] setsockopt(16, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(23, SOL_SOCKET, 0x1d /* SO_??? */, [1], 4) = 0
[pid  6118] fcntl64(23, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 91, 0) = 91
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] ioctl(4, 0x8913, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x8919, 0xbf8ab100) = 0
[pid  6118] ioctl(4, 0x891b, 0xbf8ab100) = 0
[pid  6118] close(4)                    = 0
[pid  6118] setsockopt(17, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(18, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(19, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(20, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(21, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(22, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] setsockopt(23, SOL_SOCKET, SO_REUSEADDR, [0], 4) = 0
[pid  6118] rt_sigaction(SIGSYS, {0x805f570, [], 0}, {SIG_DFL}, 8) = 0
[pid  6118] rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
[pid  6118] adjtimex({modes=61, offset=-2725, freq=4946064, maxerror=16, esterror=16, status=64, constant=4, precision=1, tolerance=33554432, time={1208803493, 75815}}) = 5
[pid  6118] rt_sigaction(SIGSYS, {SIG_DFL}, NULL, 8) = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 60, 0) = 60
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] open("/var/run/ntp/ntpd.pid", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 4
[pid  6118] fstat64(4, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40018000
[pid  6118] write(4, "6118", 4)         = 4
[pid  6118] close(4)                    = 0
[pid  6118] munmap(0x40018000, 4096)    = 0
[pid  6118] open("/etc/ntp.conf", O_RDONLY) = 4
[pid  6118] fstat64(4, {st_mode=S_IFREG|0644, st_size=2175, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40018000
[pid  6118] read(4, "################################"..., 4096) = 2175
[pid  6118] open("/etc/nsswitch.conf", O_RDONLY) = 5
[pid  6118] fstat64(5, {st_mode=S_IFREG|0644, st_size=1239, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40019000
[pid  6118] read(5, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) = 1239
[pid  6118] read(5, "", 4096)           = 0
[pid  6118] close(5)                    = 0
[pid  6118] munmap(0x40019000, 4096)    = 0
[pid  6118] open("/etc/ld.so.cache", O_RDONLY) = 5
[pid  6118] fstat64(5, {st_mode=S_IFREG|0644, st_size=103028, ...}) = 0
[pid  6118] old_mmap(NULL, 103028, PROT_READ, MAP_PRIVATE, 5, 0) = 0x4029d000
[pid  6118] close(5)                    = 0
[pid  6118] open("/lib/libnss_files.so.2", O_RDONLY) = 5
[pid  6118] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\35"..., 512) = 512
[pid  6118] fstat64(5, {st_mode=S_IFREG|0755, st_size=41737, ...}) = 0
[pid  6118] old_mmap(NULL, 33716, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0x40019000
[pid  6118] madvise(0x40019000, 33716, MADV_SEQUENTIAL|0x1) = 0
[pid  6118] old_mmap(0x40021000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0x40021000
[pid  6118] close(5)                    = 0
[pid  6118] munmap(0x4029d000, 103028)  = 0
[pid  6118] open("/etc/services", O_RDONLY) = 5
[pid  6118] fcntl64(5, F_GETFD)         = 0
[pid  6118] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid  6118] fstat64(5, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40022000
[pid  6118] read(5, "#\n# Network services, Internet s"..., 4096) = 4096
[pid  6118] read(5, "a         20/udp    # File Trans"..., 4096) = 4096
[pid  6118] read(5, "ical Address Maintenance\n#      "..., 4096) = 4096
[pid  6118] read(5, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
[pid  6118] read(5, "       Patrick McNamee <--none--"..., 4096) = 4096
[pid  6118] close(5)                    = 0
[pid  6118] munmap(0x40022000, 4096)    = 0
[pid  6118] open("/etc/services", O_RDONLY) = 5
[pid  6118] fcntl64(5, F_GETFD)         = 0
[pid  6118] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid  6118] fstat64(5, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40022000
[pid  6118] read(5, "#\n# Network services, Internet s"..., 4096) = 4096
[pid  6118] read(5, "a         20/udp    # File Trans"..., 4096) = 4096
[pid  6118] read(5, "ical Address Maintenance\n#      "..., 4096) = 4096
[pid  6118] read(5, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
[pid  6118] read(5, "       Patrick McNamee <--none--"..., 4096) = 4096
[pid  6118] close(5)                    = 0
[pid  6118] munmap(0x40022000, 4096)    = 0
[pid  6118] open("/var/lib/ntp/drift/ntp.drift", O_RDONLY) = 5
[pid  6118] fstat64(5, {st_mode=S_IFREG|0644, st_size=7, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40022000
[pid  6118] read(5, "75.471\n", 4096)   = 7
[pid  6118] close(5)                    = 0
[pid  6118] munmap(0x40022000, 4096)    = 0
[pid  6118] time([1208803493])          = 1208803493
[pid  6118] rt_sigaction(SIGPIPE, {0x40237f60, [], 0}, {SIG_IGN}, 8) = 0
[pid  6118] send(3, "<30>Apr 21 19:44:53 ntpd[6118]: "..., 98, 0) = 98
[pid  6118] rt_sigaction(SIGPIPE, {SIG_IGN}, NULL, 8) = 0
[pid  6118] open("/var/log/ntp", O_WRONLY|O_APPEND|O_CREAT, 0666) = 5
[pid  6118] fstat64(5, {st_mode=S_IFREG|0644, st_size=403567, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40022000
[pid  6118] fstat64(5, {st_mode=S_IFREG|0644, st_size=403567, ...}) = 0
[pid  6118] _llseek(5, 403567, [403567], SEEK_SET) = 0
[pid  6118] open("/etc/services", O_RDONLY) = 6
[pid  6118] fcntl64(6, F_GETFD)         = 0
[pid  6118] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid  6118] fstat64(6, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40023000
[pid  6118] read(6, "#\n# Network services, Internet s"..., 4096) = 4096
[pid  6118] read(6, "a         20/udp    # File Trans"..., 4096) = 4096
[pid  6118] read(6, "ical Address Maintenance\n#      "..., 4096) = 4096
[pid  6118] read(6, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
[pid  6118] read(6, "       Patrick McNamee <--none--"..., 4096) = 4096
[pid  6118] close(6)                    = 0
[pid  6118] munmap(0x40023000, 4096)    = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
[pid  6118] connect(6, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("212.42.1.207")}, 16) = 0
[pid  6118] getsockname(6, {sa_family=AF_INET, sin_port=htons(4777), sin_addr=inet_addr("192.168.2.2")}, [16]) = 0
[pid  6118] close(6)                    = 0
[pid  6118] open("/etc/services", O_RDONLY) = 6
[pid  6118] fcntl64(6, F_GETFD)         = 0
[pid  6118] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid  6118] fstat64(6, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40023000
[pid  6118] read(6, "#\n# Network services, Internet s"..., 4096) = 4096
[pid  6118] read(6, "a         20/udp    # File Trans"..., 4096) = 4096
[pid  6118] read(6, "ical Address Maintenance\n#      "..., 4096) = 4096
[pid  6118] read(6, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
[pid  6118] read(6, "       Patrick McNamee <--none--"..., 4096) = 4096
[pid  6118] close(6)                    = 0
[pid  6118] munmap(0x40023000, 4096)    = 0
[pid  6118] socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
[pid  6118] connect(6, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("132.146.236.132")}, 16) = 0
[pid  6118] getsockname(6, {sa_family=AF_INET, sin_port=htons(28603), sin_addr=inet_addr("192.168.2.2")}, [16]) = 0
[pid  6118] close(6)                    = 0
[pid  6118] open("/etc/services", O_RDONLY) = 6
[pid  6118] fcntl64(6, F_GETFD)         = 0
[pid  6118] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid  6118] fstat64(6, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40023000
[pid  6118] read(6, "#\n# Network services, Internet s"..., 4096) = 4096
[pid  6118] read(6, "a         20/udp    # File Trans"..., 4096) = 4096
[pid  6118] read(6, "ical Address Maintenance\n#      "..., 4096) = 4096
[pid  6118] read(6, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
[pid  6118] read(6, "       Patrick McNamee <--none--"..., 4096) = 4096
[pid  6118] close(6)                    = 0
[pid  6118] munmap(0x40023000, 4096)    = 0
[pid  6118] gettimeofday({1208803493, 87853}, NULL) = 0
[pid  6118] open("/etc/resolv.conf", O_RDONLY) = 6
[pid  6118] fstat64(6, {st_mode=S_IFREG|0644, st_size=34, ...}) = 0
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40023000
[pid  6118] read(6, "nameserver 127.0.0.1\nsearch loca"..., 4096) = 34
[pid  6118] read(6, "", 4096)           = 0
[pid  6118] close(6)                    = 0
[pid  6118] munmap(0x40023000, 4096)    = 0
[pid  6118] socket(PF_UNIX, SOCK_STREAM, 0) = 6
[pid  6118] connect(6, {sa_family=AF_UNIX, path="/var/run/.nscd_socket"}, 110) = 0
[pid  6118] writev(6, [{"\2\0\0\0\4\0\0\0\25\0\0\0", 12}, {"ntp.cis.strath.ac.uk\0", 21}], 2) = 33
[pid  6118] read(6, "\2\0\0\0\377\377\377\377\0\0\0\0\0\0\0\0\377\377\377\377"..., 32) = 32
[pid  6118] close(6)                    = 0
[pid  6118] open("/etc/host.conf", O_RDONLY) = 6
[pid  6118] fstat64(6, {st_mode=S_IFREG|0644, st_size=369, ...}) = 0
[pid  6117] exit_group(0)               = ?
[pid  6118] mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40023000
read(6, "#\n# /etc/host.conf - resolver co"..., 4096) = 369
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x40023000, 4096)                = 0
open("/etc/hosts", O_RDONLY)            = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=770, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40023000
read(6, "#\n# hosts         This file desc"..., 4096) = 770
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x40023000, 4096)                = 0
open("/etc/ld.so.cache", O_RDONLY)      = 6
fstat64(6, {st_mode=S_IFREG|0644, st_size=103028, ...}) = 0
old_mmap(NULL, 103028, PROT_READ, MAP_PRIVATE, 6, 0) = 0x4029d000
close(6)                                = 0
open("/lib/libnss_dns.so.2", O_RDONLY)  = 6
read(6, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\17\0\000"..., 512) = 512
fstat64(6, {st_mode=S_IFREG|0755, st_size=17722, ...}) = 0
old_mmap(NULL, 17352, PROT_READ|PROT_EXEC, MAP_PRIVATE, 6, 0) = 0x40023000
madvise(0x40023000, 17352, MADV_SEQUENTIAL|0x1) = 0
old_mmap(0x40027000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 6, 0x3000) = 0x40027000
close(6)                                = 0
open("/lib/libresolv.so.2", O_RDONLY)   = 6
read(6, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`+\0\000"..., 512) = 512
fstat64(6, {st_mode=S_IFREG|0755, st_size=74342, ...}) = 0
old_mmap(NULL, 73588, PROT_READ|PROT_EXEC, MAP_PRIVATE, 6, 0) = 0x402b7000
madvise(0x402b7000, 73588, MADV_SEQUENTIAL|0x1) = 0
old_mmap(0x402c6000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 6, 0xf000) = 0x402c6000
old_mmap(0x402c7000, 8052, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x402c7000
close(6)                                = 0
munmap(0x4029d000, 103028)              = 0
stat64("/etc/resolv.conf", {st_mode=S_IFREG|0644, st_size=34, ...}) = 0
gettimeofday({1208803493, 91835}, NULL) = 0
open("/etc/resolv.conf", O_RDONLY)      = 6
fstat64(6, {st_mode=S_IFREG|0644, st_size=34, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40028000
read(6, "nameserver 127.0.0.1\nsearch loca"..., 4096) = 34
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x40028000, 4096)                = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, 28) = 0
send(6, "\221\371\1\0\0\1\0\0\0\0\0\0\3ntp\3cis\6strath\2ac\2u"..., 38, 0) = 38
gettimeofday({1208803493, 93255}, NULL) = 0
poll([{fd=6, events=POLLIN, revents=POLLIN}], 1, 5000) = 1
ioctl(6, FIONREAD, [261])               = 0
recvfrom(6, "\221\371\201\200\0\1\0\2\0\7\0\2\3ntp\3cis\6strath\2ac"..., 1024, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, [16]) = 261
close(6)                                = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("130.159.196.118")}, 16) = 0
getsockname(6, {sa_family=AF_INET, sin_port=htons(26300), sin_addr=inet_addr("192.168.2.2")}, [16]) = 0
close(6)                                = 0
open("/etc/services", O_RDONLY)         = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40028000
read(6, "#\n# Network services, Internet s"..., 4096) = 4096
read(6, "a         20/udp    # File Trans"..., 4096) = 4096
read(6, "ical Address Maintenance\n#      "..., 4096) = 4096
read(6, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
read(6, "       Patrick McNamee <--none--"..., 4096) = 4096
close(6)                                = 0
munmap(0x40028000, 4096)                = 0
open("/etc/hosts", O_RDONLY)            = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=770, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40028000
read(6, "#\n# hosts         This file desc"..., 4096) = 770
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x40028000, 4096)                = 0
stat64("/etc/resolv.conf", {st_mode=S_IFREG|0644, st_size=34, ...}) = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, 28) = 0
send(6, "\221\372\1\0\0\1\0\0\0\0\0\0\5ntp2d\3mcc\2ac\2uk\0\0\1"..., 33, 0) = 33
gettimeofday({1208803493, 96575}, NULL) = 0
poll([{fd=6, events=POLLIN, revents=POLLIN}], 1, 5000) = 1
ioctl(6, FIONREAD, [198])               = 0
recvfrom(6, "\221\372\201\200\0\1\0\2\0\4\0\1\5ntp2d\3mcc\2ac\2uk\0"..., 1024, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, [16]) = 198
close(6)                                = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("130.88.203.64")}, 16) = 0
getsockname(6, {sa_family=AF_INET, sin_port=htons(4566), sin_addr=inet_addr("192.168.2.2")}, [16]) = 0
close(6)                                = 0
open("/etc/services", O_RDONLY)         = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40028000
read(6, "#\n# Network services, Internet s"..., 4096) = 4096
read(6, "a         20/udp    # File Trans"..., 4096) = 4096
read(6, "ical Address Maintenance\n#      "..., 4096) = 4096
read(6, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
read(6, "       Patrick McNamee <--none--"..., 4096) = 4096
close(6)                                = 0
munmap(0x40028000, 4096)                = 0
open("/etc/hosts", O_RDONLY)            = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=770, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40028000
read(6, "#\n# hosts         This file desc"..., 4096) = 770
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x40028000, 4096)                = 0
stat64("/etc/resolv.conf", {st_mode=S_IFREG|0644, st_size=34, ...}) = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, 28) = 0
send(6, "\221\373\1\0\0\1\0\0\0\0\0\0\3ntp\ttuxfamily\3net\0\0"..., 35, 0) = 35
gettimeofday({1208803493, 99838}, NULL) = 0
poll([{fd=6, events=POLLIN, revents=POLLIN}], 1, 5000) = 1
ioctl(6, FIONREAD, [93])                = 0
recvfrom(6, "\221\373\201\200\0\1\0\1\0\2\0\0\3ntp\ttuxfamily\3net\0"..., 1024, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, [16]) = 93
close(6)                                = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("212.85.158.10")}, 16) = 0
getsockname(6, {sa_family=AF_INET, sin_port=htons(24676), sin_addr=inet_addr("192.168.2.2")}, [16]) = 0
close(6)                                = 0
open("/etc/services", O_RDONLY)         = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=596411, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40028000
read(6, "#\n# Network services, Internet s"..., 4096) = 4096
read(6, "a         20/udp    # File Trans"..., 4096) = 4096
read(6, "ical Address Maintenance\n#      "..., 4096) = 4096
read(6, "RUTGERS.EDU>\nhttp             80"..., 4096) = 4096
read(6, "       Patrick McNamee <--none--"..., 4096) = 4096
close(6)                                = 0
munmap(0x40028000, 4096)                = 0
open("/etc/hosts", O_RDONLY)            = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=770, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40028000
read(6, "#\n# hosts         This file desc"..., 4096) = 770
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x40028000, 4096)                = 0
stat64("/etc/resolv.conf", {st_mode=S_IFREG|0644, st_size=34, ...}) = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, 28) = 0
send(6, "\221\374\1\0\0\1\0\0\0\0\0\0\4time\tflygplats\3net\0"..., 36, 0) = 36
gettimeofday({1208803493, 102714}, NULL) = 0
poll([{fd=6, events=POLLIN, revents=POLLIN}], 1, 5000) = 1
ioctl(6, FIONREAD, [257])               = 0
recvfrom(6, "\221\374\201\200\0\1\0\2\0\5\0\5\4time\tflygplats\3net"..., 1024, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.1")}, [16]) = 257
close(6)                                = 0
socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
connect(6, {sa_family=AF_INET, sin_port=htons(123), sin_addr=inet_addr("213.112.52.107")}, 16) = 0
getsockname(6, {sa_family=AF_INET, sin_port=htons(13796), sin_addr=inet_addr("192.168.2.2")}, [16]) = 0
close(6)                                = 0
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x40018000, 4096)                = 0
adjtimex({modes=3, offset=-2725, freq=4946064, maxerror=16, esterror=16, status=64, constant=4, precision=1, tolerance=33554432, time={1208803493, 103755}}) = 5
prctl(0x8, 0x1, 0, 0, 0)                = 0
socket(PF_UNIX, SOCK_STREAM, 0)         = 4
connect(4, {sa_family=AF_UNIX, path="/var/run/.nscd_socket"}, 110) = 0
writev(4, [{"\2\0\0\0\0\0\0\0\4\0\0\0", 12}, {"ntp\0", 4}], 2) = 16
read(4, "\2\0\0\0\1\0\0\0\4\0\0\0\2\0\0\0J\0\0\0\376\377\0\0\v\0"..., 36) = 36
read(4, "ntp\0x\0NTP daemon\0/var/lib/ntp\0/b"..., 41) = 41
close(4)                                = 0
chdir("/var/lib/ntp/")                  = 0
chroot("/var/lib/ntp/")                 = 0
setuid32(74)                            = 0
setresuid32(-1, 74, -1)                 = 0
capget(0x20071026, 0, {, , })           = -1 EINVAL (Invalid argument)
capset(0, 0, {CAP_NET_BIND_SERVICE|CAP_SYS_TIME, CAP_NET_BIND_SERVICE|CAP_SYS_TIME, CAP_NET_BIND_SERVICE|CAP_SYS_TIME}) = -1 EINVAL (Invalid argument)
time(NULL)                              = 1208803493
write(5, "21 Apr 19:44:53 ntpd[6118]: cap_"..., 92) = 92
munmap(0x40022000, 4096)                = 0
exit_group(-1)                          = ?
Process 6118 detached

--------------010008070904080107000504--
