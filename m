Return-Path: <linux-kernel-owner+w=401wt.eu-S967835AbXFHMud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967835AbXFHMud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937939AbXFHMuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:50:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:53838 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S937318AbXFHMuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:50:23 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1968wo3kKd6myGv4USDYarqZqW6V2Lo7Ckzx3U1ge
	94AptfxN1u5lqB
Message-ID: <46695095.2020503@gmx.net>
Date: Fri, 08 Jun 2007 14:50:29 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.54 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I just released man-pages-2.54

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages
    or mirrors: ftp://ftp.XX.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

This release includes a new page, man-pages.7, that describes the
conventions that should be used when writing pages for man-pages.  A few
other changes that may be of interest to readers of this list are are noted
below.

Cheers,

Michael


==================== Changes in man-pages-2.54 ====================

New pages
---------

man-pages.7
    mtk
        A description of the conventions that should be followed
        when writing pages for the man-pages package.

Changes to individual pages
---------------------------

fcntl.2
    mtk
        Remove misleading text about setting O_ASYNC when calling
        open(); one must use fcntl() F_SETFL for this task.

fdatasync.2
    mtk
        Converted outdated BUGS note about fdatasync() being
        equivalent to fsync() on Linux 2.2 into a NOTES note
        about this historical behaviour.

mprotect.2
    mtk, after an observation by Emmanuel Mogenet
        A much improved example program.
    mtk
        Significant rewrites and additions to description.

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
