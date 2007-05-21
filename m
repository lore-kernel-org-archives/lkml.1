Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXEUMqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXEUMqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXEUMqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:46:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:41082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755641AbXEUMqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:46:32 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/qJL8mPSnq3HRFHYM0HbasLXQ8MiYspXMztAFqKw
	GK9A9O/k2h2BLw
Message-ID: <4651894A.1090004@gmx.net>
Date: Mon, 21 May 2007 13:58:02 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.49 and man-pages-2.50 are released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I just released man-pages-2.49 and man-pages-2.50.

These releases are now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages
    or mirrors: ftp://ftp.XX.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

Changes in 2.49 that may be of interest to readers of this list are listed
below (see the "changes" file for a complete list of changes).  The notable
change in 2.50 is the dropping of a number of man1 pages, as explained in
the "Changes" file:

        Once upon time Andries added a number of Section 1 manual pages
        to man-pages.  However, since that time, those pages have not
        seen much maintenance, and are not in fact distributed in most
        distributions.  Instead most distributions supply the
        coreutils versions of these pages, which are currently
        maintained.  In addition, man-pages provides the 1p pages,
        which document the portable subset of functionality of these
        commands.  Since the man1 pages are mostly unneeded, and
        out of date, I'm removing them.

(Exceptions are intro.1, ldd.1, and time.1, which will be retained.)

Cheers,

Michael

==================== Changes in man-pages-2.49 ====================

New pages
---------

euidaccess.3
    mtk
        Manual page for euidaccess() and eaccess().

getsubopt.3
    mtk / Justin Pryzby
         Documentation of getsubopt().

Changes to individual pages
---------------------------

epoll_pwait.2
    mtk
        Added description of epoll_pwait(), new in kernel 2.6.19.

execve.2
    mtk
        Add text noting that Linux allows 'argv' and 'envp' to be
        NULL, but warning that this is non-standard and non-portable,
        and should be avoided in portable programs.
        Bug filed (http://bugzilla.kernel.org/show_bug.cgi?id=8408)
        to get this changed, but maybe that won't be done because it
        is an ABI change.
    mtk
        Added an example program.
    mtk
        Expanded the discussion of interpreter scripts and the
        'optional-arg' argument of an interpreter script.
        For further info, see
        http://homepages.cwi.nl/~aeb/std/hashexclam-1.html
        http://www.in-ulm.de/~mascheck/various/shebang/
    mtk
        Added text noting that FD_CLOEXEC causes record locks to be
        released.
    mtk
        Mention effect of MS_NOSUID mount(2) flag for set-user-ID
        programs.
    mtk
        Expanded description of handling of file descriptors during
        execve(), adding text to note that descriptors 0, 1, and 2
        may be treated specially.

readv.2
    mtk
        A fairly substantial rewrite, which among other things
        fixes the problem reported by Kyle Sluder in
        http://bugzilla.kernel.org/show_bug.cgi?id=8399
        And added some example code.

sigaction.2
    mtk
        Added text referring to the discussion of async-signal-safe
        functions in signal(7).
        A few other minor formatting and wording changes.

signal.2
    mtk
        Moved the discussion of async-signal-safe functions to signal(7).
        Added text referring to the discussion of async-signal-safe
        functions in signal(7).
        Added SEE ALSO entries referring to new bsd_signal.3 and
        sysv_signal.3 pages.

signal.7
    mtk
        Incorporated (and slightly modified) the text on
        async-signal-safe functions that was formerly in signal(2).
        Added SEE ALSO entries referring to new bsd_signal.3 and
        sysv_signal.3 pages.


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

