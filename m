Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXFLOUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXFLOUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXFLOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:20:41 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:44542 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbXFLOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:20:40 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: cannot set IP for ethernet
Date: Tue, 12 Jun 2007 16:13:47 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706121441.13561.oliver@neukum.org> <Pine.LNX.4.64.0706121531040.19578@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706121531040.19578@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121613.47718.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 12. Juni 2007 schrieb Jan Engelhardt:
> 
> On Jun 12 2007 14:41, Oliver Neukum wrote:
> >
> >with 2.6.22-rc4-git2 I am getting errors when setting IP for ethernet
> >interfaces:
> >
> >ioctl(4, SIOCSIFADDR, 0x7fff94931600)   = -1 ENOBUFS (No buffer space available)
> 
> And if you do it over netlink, as is common today?

valisk:/home/oliver # strace ip addr add 192.168.234.17/24 brd + dev eth1
execve("/sbin/ip", ["ip", "addr", "add", "192.168.234.17/24", "brd", "+", "dev", "eth1"], [/* 84 vars */]) = 0
brk(0)                                  = 0x628000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2b18e11de000
uname({sys="Linux", node="valisk", ...}) = 0
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=160918, ...}) = 0
mmap(NULL, 160918, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2b18e11df000
close(3)                                = 0
open("/lib64/libresolv.so.2", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P5\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=73920, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2b18e1207000
mmap(NULL, 2177896, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2b18e13e0000
fadvise64(3, 0, 2177896, POSIX_FADV_WILLNEED) = 0
mprotect(0x2b18e13f1000, 2093056, PROT_NONE) = 0
mmap(0x2b18e15f0000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x2b18e15f0000
mmap(0x2b18e15f2000, 7016, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x2b18e15f2000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\332\1\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1358528, ...}) = 0
mmap(NULL, 3404024, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x2b18e15f4000
fadvise64(3, 0, 3404024, POSIX_FADV_WILLNEED) = 0
mprotect(0x2b18e172b000, 2093056, PROT_NONE) = 0
mmap(0x2b18e192a000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x136000) = 0x2b18e192a000
mmap(0x2b18e192f000, 16632, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x2b18e192f000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2b18e1934000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2b18e1935000
arch_prctl(ARCH_SET_FS, 0x2b18e1934b00) = 0
mprotect(0x2b18e192a000, 12288, PROT_READ) = 0
munmap(0x2b18e11df000, 160918)          = 0
socket(PF_NETLINK, SOCK_RAW, 0)         = 3
setsockopt(3, SOL_SOCKET, SO_SNDBUF, [32768], 4) = 0
setsockopt(3, SOL_SOCKET, SO_RCVBUF, [32768], 4) = 0
bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
getsockname(3, {sa_family=AF_NETLINK, pid=12240, groups=00000000}, [16230387979418337292]) = 0
gettimeofday({1181657227, 120512}, NULL) = 0
sendto(3, "\24\0\0\0\22\0\1\3\214\250nF\0\0\0\0\0\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 20
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\370\0\0\0\20\0\2\0\214\250nF\320/\0\0\0\0\4\3\1\0\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 1004
brk(0)                                  = 0x628000
brk(0x649000)                           = 0x649000
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\24\0\0\0\3\0\2\0\214\250nF\320/\0\0\0\0\0\0\1\0\0\0I\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 20
sendmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"0\0\0\0\24\0\5\0\215\250nF\0\0\0\0\2\30\0\0\2\0\0\0\10"..., 48}], msg_controllen=0, msg_flags=0}, 0) = 48
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"$\0\0\0\2\0\0\0\215\250nF\320/\0\0\227\377\377\3770\0\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 36
dup(2)                                  = 4
fcntl(4, F_GETFL)                       = 0x8002 (flags O_RDWR|O_LARGEFILE)
fstat(4, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 2), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2b18e11df000
lseek(4, 0, SEEK_CUR)                   = -1 ESPIPE (Illegal seek)
write(4, "RTNETLINK answers: No buffer spa"..., 45RTNETLINK answers: No buffer space available
) = 45
close(4)                                = 0
munmap(0x2b18e11df000, 4096)            = 0
exit_group(2)                           = ?
Process 12240 detached

No luck, but it was not repeatable, as "ifconfig" was.

	Regards
		Oliver

