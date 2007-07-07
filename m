Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbXGGOmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbXGGOmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 10:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbXGGOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 10:41:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:34157 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751323AbXGGOl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 10:41:56 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18Ll5lHOWELLzAW2UHl0ZGME+qaprBdC+IRAujRj2
	MCQTRGYbMGLgMB
Message-ID: <468FBEB7.1000308@gmx.net>
Date: Sat, 07 Jul 2007 18:26:31 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.61 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I recently released man-pages-2.61.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

A few of the changes that may of interest to readers of this list are
supplied below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

==================== Changes in man-pages-2.61 ====================

Changes to individual pages
---------------------------

intro.2
    mtk
       Rewrite to reflect the fact that the _syscallN
       macros are no longer available.

select.2
    mtk
        Noted that 'timeout' can also be changed if select() is
        interrupted by a signal.

swapon.2
    Ivana Varekova  / mtk
        Update text for EPERM error describing the maximum number of
        swap files.  (From downstream Fedora patch.)

write.2
    mtk
        Added details about seekable files and file offset.
        Noted that write() may write less than 'count' bytes, and
        gave some examples of why this might occur.
        Noted what happens if write() is interrupted by a signal.

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

