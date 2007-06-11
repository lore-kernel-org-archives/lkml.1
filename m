Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXFKHJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXFKHJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761080AbXFKHJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:09:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:46686 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760389AbXFKHI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:08:59 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/iI5ls8b/iG4Lmbn28bh/peMN0E04UavCQSw9nOg
	FRJmv4lVE+D0u3
Message-ID: <466CF518.7040703@gmx.net>
Date: Mon, 11 Jun 2007 09:09:12 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.55 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I just released man-pages-2.55.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

Changes that may be of interest to readers of this list are noted below.

Cheers,

Michael

PS A note of thanks to my employer... much of my work on man-pages is
nowadays supported by Google, as a Google engineer 20% project.

==================== Changes in man-pages-2.55 ====================

Global changes
--------------

clone.2
getdents.2
gettid.2
ioprio_set.2
llseek.2
mmap2.2
modify_ldt.2
mq_getsetattr.2
pivot_root.2
quotactl.2
readdir.2
sysctl.2
syslog.2
tkill.2
    mtk, after a note by Mike Frysinger
        Updated to reflect the fact that the _syscallN() macros
        have gone away,

Changes to individual pages
---------------------------

bind.2
    mtk
        Expand example program, and move it to new EXAMPLE section.
        Added text pointing to example in getaddrinfo.3.

signal.2
    mtk, after a note from Alexander Taboriskiy
        Strengthen warning against the use of signal().
        Added siginterrupt(3) to SEE ALSO list.
    mtk
        Rewrote various parts; added an ERRORS section.

stat.2
    mtk
        Added EXAMPLE program.

sysctl.2
    mtk
        Improved the example program.

getaddrinfo.3
    mtk
        Add example programs.
        Add getnameinfo() to SEE ALSO list.

inotify.7
    mtk
        Added text describing what happens when the buffer given to
        read(2) is too small to return information about the next event,
        and noting the behaviour change in 2.6.21.

ld.so.8
    mtk
        Simplify text describing --inhibit-rpath.
    mtk, after a note by John Reiser
        Describe use of $ORIGIN in rpath.

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
