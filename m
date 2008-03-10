Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYCJPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYCJPe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYCJPeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:34:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYCJPem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=EyxqUgvjCoTqrwNQ/9TRys0Gzo1mwMvYyF6dMUbSbGCfs8+cbjbaaWV1KhmI9czQqUdQicfwW/RwZOptn6hnrDqT0qOGt/Kslcgm8JILJnir038lPJTTFyV+029FaoJqPP4p/BQ+IyvVxKbEmJjQrcsVZ5Sz/BbeWaiHAGNaRww=
Message-ID: <47D554BB.6000801@gmail.com>
Date: Mon, 10 Mar 2008 16:33:15 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.79 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-2.79.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

A full list of the changes in this release can be seen at
http://www.kernel.org/doc/man-pages/changelog.html
A summary of the changes in this release that may be of interest to readers
of this list is provided below.

Cheers,

Michael


==================== Changes in man-pages-2.79 ====================

New pages
---------

timerfd_create.2
    mtk, with input and review from Davide Libenzi
        Documents the timerfd_create(), timerfd_settime(), and
        timerfd_gettime() system calls, which are new in 2.6.25.


Changes to individual pages
---------------------------

syslog.2
    Jeremy Kerr
        Add info on command type 10.
        Add details on types 6, 7, 8, and 9.
        Minor grammar fix.
    mtk
        Update LOG_BUF_LEN details.
        Update RETURN VALUE section.
        Notes capability requirements under EPERM error.
        Minor fix to description of type==3 and type==4.
        Other minor edits.

proc.5
    Fernando Luis Vázquez Cao
        Update /proc/[number]/cmdline description.
        It used to be true that the command line arguments were
        not accessible when the process had been swapped out.
        In ancient kernels (circa 2.0.*) the problem was that the
        kernel relied on get_phys_addr to access the user space buffer,
        which stopped working as soon as the process was swapped out.
        Recent kernels use get_user_pages for the same purpose and thus
        they should not have that limitation.

epoll.7
    Davide Libenzi / mtk
        Clarify the somewhat unintuitive behavior that occurs if a file
        descriptor in an epoll set is closed while other file descriptors
        referring to the same underlying open file description remain
        open.
        See also http://thread.gmane.org/gmane.linux.kernel/596462/.
    mtk
        Clarify error that occurs if we add an epoll fd to its own set.
    mtk
        A few minor rewordings.
    mtk, after a note by Chris Heath
        Rework Q1/A1, describing what happens when adding the same
        file descriptor twice to an epoll set, and when adding duplicate
        file descriptors to the same epoll set.
    Heikki Orsila / mtk / Davide Libenzi
        Clarify Q9/A9 to discuss packet/token-oriented files.
    mtk, after comments by Devide Libenzi and Chris Heath
        Added Q0/A0, making explicit that the key for items in an epoll
        set is [file descriptor, open file description].
    mtk, after a note by Ron Burk
        Change A3, to note that when events are available,
        the epoll file descriptor will indicate as being readable.
    mtk
        Add some further explanation to Q5/A5 about why an epoll file
        descriptor cannot be passed across a Unix domain socket.

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html


