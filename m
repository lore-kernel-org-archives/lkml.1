Return-Path: <linux-kernel-owner+w=401wt.eu-S938218AbXGTIhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938218AbXGTIhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXGTIh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:37:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:58137 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763470AbXGTIhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:37:23 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+T8zIQ1BWTr+jAohNEBqSjqW8CyA/BoIIRVBXuZn
	eea72PJE9sI9mv
Message-ID: <46A05CA6.3090006@gmx.net>
Date: Fri, 20 Jul 2007 08:56:38 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.63 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I recently released man-pages-2.63.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

Changes in this release that may be of interest to readers of this list are
noted below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

==================== Changes in man-pages-2.63 ====================

New pages
---------

sgetmask.2
    mtk
        A real man page for sgetmask(2) and ssetmask(2).
        (This page replaces a previous link of the same, which linked
        signal.2.)

spu_create.2
    Arnd Bergmann with additional work by Eduardo M. Fleury and mtk
        Document the PowerPC SPU spu_create() system call.
        (Originally taken from the kernel source file
        Documentation/filesystems/spufs.txt.)

spu_run.2
    Arnd Bergmann with additional work by Eduardo M. Fleury and mtk
        Document the PowerPC SPU spu_run() system call.
        (Originally taken from the kernel source file
        Documentation/filesystems/spufs.txt.)

spufs.7
    Arnd Bergmann with additional work by Eduardo M. Fleury and mtk
        Document the PowerPC SPU file system.
        (Originally taken from the kernel source file
        Documentation/filesystems/spufs.txt.)


New links
---------

chown32.2
fchown32.2
getegid32.2
geteuid32.2
getgid32.2
getgroups32.2
getresgid32.2
getresuid32.2
getuid32.2
lchown32.2
setfsgid32.2
setfsuid32.2
setgid32.2
setgroups32.2
setregid32.2
setresgid32.2
setresuid32.2
setreuid32.2
setuid32.2
    mtk
        Added as link to corresponding page without "32".

fcntl64.2
fstat64.2
fstatat64.2
fstatfs64.2
ftruncate64.2
getdents64.2
lstat64.2
pread64.2
pwrite64.2
sendfile64.2
stat64.2
statfs64.2
truncate64.2
    mtk
        Added as link to corresponding page without "64".

__clone2.2
clone2.2
    mtk
        Links to clone.2.

ugetrlimit.2
    mtk
        Link to getrlimit.2.

mq_notify.2
mq_open.2
mq_timedreceive.2
mq_timedsend.2
mq_unlink.2
    mtk
        Added as links to corresponding section 3 pages.

fadvise64.2
fadvise64_64.2
    mtk
        Links to posix_fadvise.2.

rt_sigaction.2
rt_sigpending.2
rt_sigprocmask.2
rt_sigtimedwait.2
    mtk
        Added as link to corresponding page without "rt_" prefix.

rt_sigqueueinfo.2
    mtk
        Link to sigqueue.2.

madvise1.2
tuxcall.2
vserver.2
    mtk / Ivana Varekova
        Link to unimplemented.2.


Changes to individual pages
---------------------------

access.2
    mtk
        Fairly substantial rewrites of various parts,
        and a few additions.

chown.2
    mtk
        Added an example program.

killpg.2
    mtk
        Note that killpg() is actually a library function on Linux.

mmap.2
    mtk
        Added note that glibc mmap() wrapper nowadays invokes mmap2().

mmap2.2
    Ivana Varekova / mtk
        On most platforms the unit for 'offset' is 4096 bytes, not
        the system page size.
    mtk
        Rewrote NOTES to note that glibc mmap() wrapper nowadays
        invokes this system call.
    mtk
        Added an EXAMPLE program.

semop.2
    mtk
        Add an example code segment.

sigqueue.2
    mtk
        Added info on rt_sigqueueinfo(2).

sigwaitinfo.2
    mtk
        Noted that sigwaitinfo() is a library function implemented on
        top of sigtimedwait().

stat.2
    mtk
        Add notes on the different system call interfaces that
        have appeared over time.

uname.2
    mtk
        Add notes on the different system call interfaces that
        have appeared over time.

proc.5
    mtk
        Update/correct text on /proc/malloc.
    mtk, after a note by Pierre Habouzit, and a few comments
            by Justin Pryzby
        Update description of /proc/PID/stat to match 2.6.21.
        See Debian bug 417933.

inotify.7
    mtk
        IN_DONT_FOLLOW and IN_ONLYDIR are only available from 2.6.15.

signal.7
    Stepan Kasal / mtk
        Note SIGRTMIN value depends on glibc.
    mtk
        Various rewrites and additions to the text in real-time signals.
        Add SEE ALSO reference to sgetmask.2.

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.


