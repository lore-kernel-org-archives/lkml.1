Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbYDPRZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbYDPRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbYDPRZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:25:07 -0400
Received: from mail.transmode.se ([83.241.175.147]:39655 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762952AbYDPRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:25:05 -0400
Subject: Current git tree broke busybox start-stop-daemon
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Wed, 16 Apr 2008 19:25:02 +0200
Message-Id: <1208366702.5911.119.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

root@localhost:~# start-stop-daemon --stop --name eq_ppp_mgr
start-stop-daemon: lseek: Invalid argument

root@localhost:~# strace start-stop-daemon --stop --name eq_ppp_mgr
execve("/sbin/start-stop-daemon", ["start-stop-daemon", "--stop", "--name", "eq_ppp_mgr"], [/* 12 vars */]) = 0
uname({sys="Linux", node="localhost.localdomain", ...}) = 0
brk(0)                                  = 0x1007c000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x48017000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/opt/appl/executing/lib/tls/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/executing/lib/tls/ppc603", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/executing/lib/tls/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/executing/lib/tls", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/executing/lib/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/executing/lib/ppc603", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/executing/lib/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/executing/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
open("/opt/appl/started/lib/tls/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/started/lib/tls/ppc603", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/started/lib/tls/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/started/lib/tls", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/started/lib/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/started/lib/ppc603", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/started/lib/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/started/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
open("/opt/appl/next/lib/tls/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/next/lib/tls/ppc603", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/next/lib/tls/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/next/lib/tls", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/next/lib/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/next/lib/ppc603", 0xbfb940a0) = -1 ENOENT (No such file or directory)
open("/opt/appl/next/lib/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/opt/appl/next/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=64, ...}) = 0
mmap(NULL, 64, PROT_READ, MAP_PRIVATE, 3, 0) = 0x48018000
close(3)                                = 0
open("/lib/tls/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/ppc603", 0xbfb940a0)   = -1 ENOENT (No such file or directory)
open("/lib/tls/libc.so.6", O_RDONLY)    = -1 ENOENT (No such file or directory)
stat64("/lib/tls", 0xbfb940a0)          = -1 ENOENT (No such file or directory)
open("/lib/ppc603/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/ppc603", 0xbfb940a0)       = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\1\314"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1345728, ...}) = 0
mmap(0xfea7000, 1346452, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xfea7000
madvise(0xfea7000, 1346452, MADV_SEQUENTIAL|0x1) = 0
mprotect(0xffd8000, 97172, PROT_NONE)   = 0
mmap(0xffe8000, 24576, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x131000) = 0xffe8000
mmap(0xffee000, 7060, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xffee000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x48019000
mprotect(0xffe8000, 8192, PROT_READ)    = 0
mprotect(0x48026000, 4096, PROT_READ)   = 0
munmap(0x48018000, 64)                  = 0
open("/dev/urandom", O_RDONLY)          = 3
read(3, "a\25\24G", 4)                  = 4
close(3)                                = 0
getuid()                                = 0
open("/proc", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
brk(0)                                  = 0x1007c000
brk(0x1009d000)                         = 0x1009d000
getdents64(3, /* 35 entries */, 1024)   = 1024
getdents64(3, /* 40 entries */, 1024)   = 1024
open("/proc/1/stat", O_RDONLY|O_LARGEFILE) = 4
_llseek(4, 0, 0xbfb94898, SEEK_END)     = -1 EINVAL (Invalid argument)
write(2, "start-stop-daemon: lseek: Invali"..., 43start-stop-daemon: lseek: Invalid argument
) = 43
exit_group(1)                           = ?
Process 555 detached


So it appears that lseek is no longer allowed for /proc/1/stat
Bug or feature?
start-stop-daemon works fine in 2.6.23

  Jocke
