Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbYFFOQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbYFFOQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbYFFOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:16:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:11243 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYFFOQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=C3StI1WQXijc2bg7R1YKMJXSFf1iAGiETy4Z8ezANXi7nmegG/ww2awYAvM/Ezpf6m
         uN/QiDoLf5H6cccE0HeiuqC+BesPr444+au8GAe5B3EA5AyB2xSVE5PGuhpnO82t46am
         1F/Iq4oJYQ51ov8zZx8g7MelonD1XAxZ/72Lc=
Message-ID: <4849468B.2070803@gmail.com>
Date: Fri, 06 Jun 2008 16:15:39 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: manpages-fr maintainer <manpagesfr@free.fr>
Subject: man-pages-2.80 and man-pages-fr-2.80.0 are released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

The Linux man-pages maintainer, Michael Kerrisk, and the maintainer
of the French translation of man-pages, Alain Portal, proudly
announce the release of man-pages-2.80 in English original and
French translation.

This will be the last 2.xx release, reflecting the fact that many
changes are soon coming for man-pages (and anyway we were running
low on 2.xx numbers. ;-).)  More details soon.

The English version:

    man-pages-2.80.tar.gz - man pages for Linux

is now available for download, and viewable online, at:

    http://www.kernel.org/pub/linux/docs/man-pages

The (rather long) list of changes in this release can be seen at
http://www.kernel.org/doc/man-pages/changelog.html#release_2.80
A short summary of the changes in this release that may be
of interest to readers of this list is provided below.

The French translation is available for download here:

    http://manpagesfr.free.fr/download.html

The translated pages are viewable online, along with some translated man
pages from other projects, here:

    http://manpagesfr.free.fr/consulter.html

    Comments and suggestions for the French translation can be
    sent to manpagesfr@free.fr.

Cheers,

Michael

==================== Changes in man-pages-2.80 ====================

New pages
---------

random_r.3
    mtk, after a suggestion by aeb
        Documents random_r(3), srandom_r(3), initstate_r(2), and
        setstate_r(3), which are the reentrant equivalents of
        random(3), srandom(3), initstate(3), and setstate(3).


Changes to individual pages
---------------------------

clone.2
    mtk
        Added note that CLONE_STOPPED (which no-one uses anyway) is
        now deprecated.

epoll_create.2
    mtk
        Add NOTES section pointing out that 'size' argument is unused
        since kernel 2.6.8.

futex.2
    mtk, after a note from Adrian Bunk
        FUTEX_FD has been removed, as of kernel 2.6.26.

futimesat.2
    mtk
        Note that this system call is made obsolete by utimensat(2).

getpriority.2
    mtk, after a note from Ingo Molnar
        Add text in NOTES about the punchier effect of nice values in
        kernel 2.6.23 and later.

mmap.2
    mtk, with input from Nick Piggin
        MAP_POPULATE supports both file and anonymous mappings.
        Since 2.6.23, MAP_POPULATE supports private mappings.
        Since 2.6.23, MAP_NONBLOCK causes MAP_POPULATE to be a no-op.

open.2
    mtk
        More than just ext2 supports "mount -o bsdgroups" nowadays,
        so make the discussion about group ownership of new files a bit
        more generic.

sched_setscheduler.2
    mtk, with input from Ingo Molnar
        Add description of SCHED_IDLE policy (new in 2.6.23).

signalfd.2
    mtk
        Added BUGS text noting that before kernel 2.6.25, the ssi_int
        and ssi_ptr fields are not set.
        Added comments describing fields in signalfd_siginfo structure.
        Update field names in example program (s/signo/ssi_signo/).

sync_file_range.2
    mtk / Andrew Morton
        Remove statement that (SYNC_FILE_RANGE_WAIT_BEFORE |
        SYNC_FILE_RANGE_WRITE | SYNC_FILE_RANGE_WAIT_AFTER) is
        a traditional fdatasync(2) operation.
        See https://bugzilla.mozilla.org/show_bug.cgi?id=421482
        comments 129 to 131.

syscalls.2
    mtk
        This page is now up to date as at kernel 2.6.25.

utime.2
    mtk
        Clarify explanation of EACCES and EPERM errors.
        Clarified discussion of capabilities, and noted that
        CAP_DAC_OVERRIDE also has a role.

futimes.3
    mtk
        Add documentation of lutimes(), which appeared in glibc 2.6.

credentials.7
    mtk
        NOTES: Pthreads requires that all threads share the same UIDs and
        GIDs.  But the Linux kernel maintains separate UIDs and GIDs for
        every thread.  NPTL does some work to ensure that credential
        changes by any thread are carried through to all POSIX threads in
        a process.

inotify.7
    mtk
        Document SIGIO feature (new in 2.6.25) for inotify file descriptors.
        Note that select()/poll()/epoll_wait() indicate a ready inotify
        file descriptor as readable.
        Document IN_ATTRIB in a little more detail.

pthreads.7
    mtk
        Add list of thread-safe functions.

standards.7
    mtk
        Add a section on the upcoming POSIX revision.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html







