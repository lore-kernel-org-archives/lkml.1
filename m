Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbXDHSla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbXDHSla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXDHSl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:41:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:40458 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751766AbXDHSl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:41:29 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/3MDo+Yiz3QDC+Su7172/kkP2Xy0+d5sIGSE2hjY
	w2Vxuu/bKwB/Tu
Message-ID: <46193754.40203@gmx.net>
Date: Sun, 08 Apr 2007 20:41:24 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: emogenet@google.com, lhawthorn@google.com, dibona@google.com
Subject: man-pages-2.44 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

After a long hiatus, a new man-pages release...

And a happy announcement!  My work on man-pages is now partially supported
by my employer, Google.  Henceforth, something up to 20% [*] of my working
week (depending on other time pressures...) will be spent on man-pages
maintenance.  Thanks, Google!

So...

I've released man-pages-2.44.

This release is now available for download at:

    ftp://ftp.kernel.org/pub/linux/docs/manpages
    or mirrors: ftp://ftp.XX.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

Cheers,

Michael

[*] http://www.google.com/support/jobs/bin/static.py?page=about.html
http://en.wikipedia.org/wiki/Google#.22Twenty_percent.22_time

=======

This release contains a very large number of changes.  Among the changes
that may be of interest to readers of this list are the following:

New pages
---------

termio.7
    mtk, after a bit of prodding by Reuben Thomas
        A brief discussion of the old System V termio interface,
        with pointers to pages that will contain the information
        that the reader probably wants.

Changes to individual pages
---------------------------

access.2
    mtk
        Since 2.6.20, access() honours the MS_NOEXEC mount flag.

mincore.2
    Nick Piggin
        Kernel 2.6.21 fixes several earlier bugs in mincore().
    mtk
        Rewrote various parts to make the page clearer.

mmap.2
    mtk
        Rewrote and reorganised various parts to be clearer.

mount.2
    mtk / Val Henson
        Document MS_RELATIME, new in Linux 2.6.20.

semop.2
    mtk
        If sops contains multiple operations, then these are performed
        in array order.  All Unix systems that I know of do this,
        and some Linux applications depend on this behaviour.  SUSv3
        made no explicit statement here, but SUSv4 will explicitly
        require this behaviour.

ptrace.2
    Chuck Ebbert
        When the parent receives an event with PTRACE_EVENT_* set,
        the child is not in the normal signal delivery path.  This
        means the parent cannot do ptrace(PTRACE_CONT) with a signal
        or ptrace(PTRACE_KILL).  kill() with a SIGKILL signal can be
        used instead to kill the child process after receiving one
        of these messages.

time.7
    mtk
        Since kernel 2.6.20, the software clock can also be 300 HZ.


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

