Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYFYQSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYFYQSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYFYQSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:18:09 -0400
Received: from mail.jambit.com ([62.245.207.83]:41434 "EHLO mail.jambit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785AbYFYQSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:18:07 -0400
Message-ID: <48626EE3.70708@gmail.com>
Date: Wed, 25 Jun 2008 18:14:27 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Jim Zemlin <jzemlin@linux-foundation.org>
Subject: man-pages-3.01 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.01.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/06/man-pages-301-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-3.01 ====================

New and rewritten pages
-----------------------

acct.5
     mtk
         A complete rewrite of this page, now with much more detail.

hostname.7
     mtk
         A description of hostname resolution.  Taken from FreeBSD 6.2,
         and lightly edited for man-pages style.

symlink.7
     mtk
         A description of symbolic links.  Taken from FreeBSD 6.2, but
         heavily edited for Linux details, improved readability, and
         man-pages style.


Newly documented interfaces in existing pages
---------------------------------------------

getrlimit.2
     mtk / Peter Zijlstra
         Add description of RLIMIT_RTTIME limit, new in 2.6.25.

mkstemp.3
     mtk
         Add description of mkostemp(), new in glibc 2.7.

core.5
     mtk, after a note by Petr Gajdos; review by Neil Horman
         Document core_pattern pipe syntax, which appeared in
         kernel 2.6.19.
         Add an example program demonstrating use of core_pattern
         pipe syntax.
     mtk
         Document /proc/PID/coredump_filter, new in kernel 2.6.23.
         Documentation was based on the text in
         Documentation/filesystems/proc.txt, plus testing, and
         checking the kernel source.

proc.5
     mtk
         Document /proc/PID/oom_score, which was new in kernel 2.6.11.
         This file displays the "badness" score of the process, which
         provides the basis for OOM-killer decisions.
     mtk
         Document /proc/PID/oom_adj, which was new in kernel 2.6.11.
         This file influences the oom_score of a process.
     mtk
         Document /proc/PID/limits, which was new in 2.6.24.
         This file displays a process's resource limits.
     mtk
         Document /proc/PID/fdinfo/*, which was new in 2.6.22.
         These files display info about each descriptor opened by the
         process: the current file offset, and the file access mode +
         file status flags as set in open() or fcntl(F_SETFL).
     mtk
         Document /proc/PID/mountinfo, which was new in 2.6.26.
         This file displays information about mount points.
         Closely based on text from Documentation/filesystems/proc.txt.
     mtk
         Document /proc/PID/mountstats, which was new in 2.6.17.
         This file displays statistics about mount points.
     mtk
         Document /proc/PID/status.
     Samuel Thibault / mtk, review by Laurent Vivier,
                 Christian Borntraeger, and Andrew P
         Document guest (virtual CPU) time field in /proc/stat.
         Document guest (virtual CPU) time fields in /proc/PID/stat.


Changes to individual pages
---------------------------

chmod.2
     mtk
         Clarify description of chmod() and fchmod().
         Add further detail on S_ISUID, S_ISGID, and S_ISVTX permissions.

chown.2
     mtk
         Describe rules governing ownership of new files (bsdgroups
         versus sysvgroups, and the effect of the parent directory's
         set-group-ID permission bit).

getdents.2
     mtk, after a note from George Spelvin
         Document d_type field, present since kernel 2.6.4.

getitimer.2
     mtk
         Linux 2.6.16 removed the MAX_SEC_IN_JIFFIES ceiling on timer
         values.

nanosleep.2
     mtk, after a report from Stephane Chazelas
         Remove crufty discussion of HZ, and replace with a pointer
         to time(7).
         See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=485636
     mtk, after some discussions with Bart Van Assche and Roman Zippel
         NOTES: describe CLOCK_REALTIME versus CLOCK_NANOSLEEP
         See also http://thread.gmane.org/gmane.linux.kernel/696854/
         "nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?"
     mtk
         Replace mentions of "process' by "thread".
         NOTES: describe case where clock_nanosleep() can be preferable.
         Some minor rewrites.

open.2
     mtk, after a note from Christoph Hellwig
         NOTES: Note that access mode flags are not single bits,
         and document the Linuxism "access mode 3".
         See also http://thread.gmane.org/gmane.linux.kernel/653123.

sched_setscheduler.2
     mtk, after a note by Andrew Clayton
         Rewrote and restructured various parts of the page for greater
         clarity.
     mtk
         Add more detail to the rules that are applied when an
         unprivileged process with a non-zero RLIMIT_RTPRIO limit
         changes policy and priority.

syscalls.2
     mtk
         Added system call history back to version 1.2.

adjtime.3
     mtk
         The longstanding bug that if delta was NULL, olddelta
         didn't return the outstanding clock adjustment, is now fixed
         (since glibc 2.8 + kernel 2.6.26).
         http://sourceware.org/bugzilla/show_bug?id=2449
         http://bugzilla.kernel.org/show_bug.cgi?id=6761

getaddrinfo.3
     mtk
         Improve description or 'hints' and 'res' arguments.
         Add details on numeric strings that can be specified for 'node'.
         Other fairly major restructurings and rewrites to improve
         logical structure and clarity of the page.
         SEE ALSO: Add hostname(7).

inet.3
     mtk / Stephane Chazelas
         inet_aton() is *not* in POSIX.1.
         Rewrote discussion of why inet_addr() is disfavored.
         SEE ALSO: Add getaddrinfo(3).
         as per http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=482979.
     mtk, after a note by Stephane Chazelas
         Describe the various address forms supported by inet_aton().
     mtk
         Rewrite description of inet_network().
         Clarify discussion of inet_lnaof(), inet_netof(), and inet_makeaddr().
         Add discussion of Classful Addressing, noting that it is obsolete.
         Added an EXAMPLE program.
     mtk
         Relocate discussion of i386 byte order to NOTES.
         Note that inet_aton() returns an address in network byte order.
         SEE ALSO: Add byteorder(3) and getnameinfo(3).

inet_pton.3
     mtk / Stephane Chazelas
         Remove statement that inet_pton() extends inet_ntoa();
         that's not really true, since inet_pton() doesn't support
         all of the string forms that are supported by inet_ntoa().
         SEE ALSO: Add getaddrinfo(3).
         as per http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=482987.
     mtk
         Describe IPv6 address formats.
         Describe dotted decimal format in more detail.
         Add an example program.
     mtk
         Remove unneeded header files from SYNOPSIS.
         Make NAME line more precise.
         Make description of return value more precise.
         SEE ALSO: Add inet(3).

readdir.3
     mtk
         Document DT_LNK (symbolic link) for d_type field.
         Reorder DT_ entries alphabetically.

scanf.3
     mtk, after a note from Stephane Chazelas
         Add an ERRORS section documenting at least some of the errors
         that may occur for scanf().
         See also http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=487254.
     mtk, after a note from Stephane Chazelas; review by Stephane Chazelas
         Document the GNU 'a' modifier for dynamically allocating strings.
         See also http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=487254.
         Document the GNU 'm' modifier for dynamically allocating strings.

random.4
     George Spelvin (taking time out from his busy Broadway schedule),
     with some tweaks by Matt Mackall and mtk
         Add a Usage subsection that recommends most users to use
         /dev/urandom, and emphasizes parsimonious usage of
         /dev/random.

locale.5
     Petr Baudis <pasky@suse.cz>
         LC_TIME: Describe first_weekday and first_workday.

proc.5
     mtk
         The vaious CPU time fields in /proc/stat and /proc/PID/stat
         return time in clock ticks (USER_HZ, cputime_to_clock_t(),
         sysconf(_SC_CLK_TCK)).
         Updated, clarified and expanded the description several
         fields in /proc/[number]/stat.
     mtk
         Clarified and expanded the description of /proc/[number]/fd.
     mtk
         Updated and clarified the description of /proc/[number]/statm.
     mtk
         Updated and clarified the description of /proc/sys/fs/dentry-state.

time.7
     mtk, with some suggestions from Bart Van Assche and Thomas Gleixner
         Added some details about where jiffies come into play.
         Added section on high-resolution timers.
         Mentioned a few other time-related interfaces at various
         points in the page.
         See http://thread.gmane.org/gmane.linux.kernel/697378.

unix.7
     mtk, after a note by Samuel Thibault
         Provide a clear description of the three types of address that
         can appear in the sockaddr_un structure: pathname, unnamed,
         and abstract.

