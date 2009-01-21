Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbZAUMZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbZAUMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbZAUMZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:25:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:21386 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbZAUMZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:25:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=AE3zjL9KldaRqJu9CQlfac6mYGwpX5z4tfF4yUrqja5k7uYHxCh35SlfAV97dy1H0z
         HiaSz+Kjx1lmyuEFY4RYy7hkHn1D2/EgcD4blKhI2F+vkUX5SYHRFIA/if1VosrG7A9X
         R9GnASHZ9A4AUFOU4UQkQ40wiWxL80l9NUD1o=
Message-ID: <4977141B.8060807@gmail.com>
Date: Thu, 22 Jan 2009 01:24:59 +1300
From: Michael Kerrisk <mtk.manpages@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.17 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.16.tar.gz - man pages for Linux

This release is now available for download at:

  http://www.kernel.org/pub/linux/docs/man-pages
  or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

  git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/01/man-pages-317-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael

==================== Changes in man-pages-3.17 ====================

New and rewritten pages
-----------------------

endian.3
    Michael Kerrisk
        New page documenting byte order conversion functions
            Document functions (new in glibc 2.9) for conversion between
            host byte order and big-/little- endian byte order:
            htobe16(), htole16(), be16toh(), le16toh(),
            htobe32(), htole32(), be32toh(), le32toh(),
            htobe64(), htole64(), be64toh(), le64toh()

getifaddrs.3
    Petr Baudis
        New page documenting getifaddrs(3) and freeifaddrs(3)
            Many edits and changes of Petr's initial draft by mtk

cp1251.7
    Lefteris Dimitroulakis
        New page documenting CP 1251 (Windows Cyrillic) character set

iso-8859-10.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-10 character set

iso_8859-13.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-13 character set

iso_8859-14.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-14 character set

iso_8859-3.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-3 character set

iso_8859-5.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-5 character set

iso_8859-8.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-8 character set

koi8-u.7
    Lefteris Dimitroulakis
        New page documenting KOI8-U character set


Newly documented interfaces in existing pages
---------------------------------------------

epoll.7
    Michael Kerrisk
        Document /proc interfaces for limiting kernel memory usage
            Document the following /proc files that were added in
            Linux 2.6.28:
            /proc/sys/fs/epoll/max_user_instances
            /proc/sys/fs/epoll/max_user_watches

netdevice.7
    Michael Kerrisk
        Document recently added interface flags
            IFF_LOWER_UP (since Linux 2.6.17)
            IFF_DORMANT (since Linux 2.6.17)
            IFF_ECHO (since Linux 2.6.25)

            Documentation taken from comments in <linux/if.h>


