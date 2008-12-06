Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYLFEj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYLFEj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 23:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYLFEjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 23:39:15 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:53967 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYLFEjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 23:39:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=osOSKxr4vlPu9BbV0dwLQ9EVMCWMnUwuc10PCP6xbsT2vCPloM/gOIDZyiKjoR6g5T
         fm5aFY7U76MDhWssxkkMc/qNZyTtLjBUxhote3bwpXr4IXIbma9Y1JzWWmoHqSbcQNCL
         HiNQyr9fFnJoT+OZpcRzEQJnbeaBW44e5p8+M=
Message-ID: <493A01E0.1070705@gmail.com>
Date: Fri, 05 Dec 2008 23:38:56 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: man-pages-3.15 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.15.tar.gz - man pages for Linux

This release is now available for download at:

  http://www.kernel.org/pub/linux/docs/man-pages
  or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

  git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/12/man-pages-315-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridges list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael

==================== Changes in man-pages-3.15 ====================

Released: 2008-12-05, Bucaramanga

New and rewritten pages
-----------------------

makedev.3
    Michael Kerrisk
        New page for makedev(), major(), and minor() macros

pthread_cleanup_push_defer_np.3
    Michael Kerrisk
        New page for pthread_cleanup_push_defer_np(3) and
        pthread_cleanup_pop_restore_np(3)


Newly documented interfaces in existing pages
---------------------------------------------

accept.2
    Michael Kerrisk
        Document accept4() system call, new in Linux 2.6.28

fmemopen.3
    Petr Baudis
        Add description of open_wmemstream(3)

tcp.7
    Michael Kerrisk
        Document MSG_TRUNC flag for TCP sockets


Changes to individual pages
---------------------------

accept.2
    Michael Kerrisk
        Clarify details when returned address is truncated
            If the returned address is truncated, the 'addrlen' argument
            indicates the actual size of the address, rather than a count
            of the number of bytes in the truncated buffer.

            Also clarify that if 'addr' argument is NULL, then 'addrlen'
            should is unused, and should also be NULL.


mmap.2
    Michael Kerrisk
        Loosen language around how 'addr' hint is interpreted
            Mel Gorman reported that in Linux 2.6.27, 'addr' is rounded
            down to a page boundary.

            Before kernel 2.6.26, if 'addr' was taken as a hint, it was
            rounded up to the next page boundary.  Since Linux 2.6.24,
            it is rounded down.  Therefore, loosen the description of
            this point to say that the address is rounded to "a nearby
            page boundary".

recv.2
    Michael Kerrisk
        Clarify details when returned address is truncated
            If the recvfrom() returned address is truncated, the 'fromlen'
            argument indicates the actual size of the address, rather than
            a count of the number of bytes in the truncated buffer.

            Also clarify that the 'from' argument can be NULL, in which
            case 'fromlen' should is unused, and should also be NULL.
    Michael Kerrisk
        Internet datagram and netlink sockets support MSG_TRUNC for recv(2)
            Internet datagram (since Linux 2.4.27/2.6.8),
            and netlink (since Linux 2.6.22) sockets support
            the MSG_TRUNC flag for recv(2).

tcp.7
    Michael Kerrisk
        Note that MSG_PEEK can be used on out-of-band data

