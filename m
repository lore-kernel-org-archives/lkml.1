Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYH0Oht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYH0Oht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbYH0OhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:37:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbYH0OhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:37:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=Lhux9TLdpjMWK1WeiosrrWNf2GnJFpL39PVvFTfda383q1OUCkCCCBjDJyV4qJMmdM
         0vd7oHJ8VbFl3Zr29iw2Xeq1zIzRQDZKl2xXpOm+EVkLhzCb77B7DsZHTk8vpdBJYxOI
         xCEqCAXp+5uTULTYE8WVdtkToTXIlnZaP+kLw=
Message-ID: <48B56594.6040807@gmail.com>
Date: Wed, 27 Aug 2008 16:32:52 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.08 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.08.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/08/man-pages-308-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael


==================== Changes in man-pages-3.08 ====================

Released: 2008-08-27, Zurich


New and rewritten pages
-----------------------

getnetent_r.3
     mtk
         Documents getnetent_r(), getnetbyname_r(),
         and getnetbyaddr_r(), the reentrant equivalents of
         getnetent(), getnetbyname(), and getnetbyaddr().

getprotoent_r.3
      mtk
         Documents getprotoent_r(), getprotobyname_r(), and
         getprotobynumber_r(), the reentrant equivalents of
         getprotoent(), getprotobyname(), and getprotobynumber().

getrpcent_r.3
      mtk
         Documents getrpcent_r(), getrpcbyname_r(), and
         getrpcbynumber_r(), the reentrant equivalents of
         getrpcent(), getrpcbyname(), and getrpcbynumber().

getservent_r.3
      mtk
         Documents getservent_r(), getservbyname_r(), and
         getservbyport_r(), the reentrant equivalents of
         getservent(), getservbyname(), and getservbyport().

numa.7
     mtk
         A new page giving overview details for the Linux NUMA interfaces.
         Incorporates some material from mbind.2, and the description
         of /proc/PID/numa_maps from proc.5.


Changes to individual pages
---------------------------

link.2
     mtk
         Note kernel version where Linux stopped following symbolic
         links in 'oldpath'; see also http://lwn.net/Articles/294667.
         POSIX.1-2008 makes it implementation-dependent whether or not
         'oldpath' is dereferenced if it is a symbolic link.
         Add a reference to linkat(2) for an interface that allows
         precise control of the treatment of symbolic links.

pthreads.7
     mtk
         Update thread-safe functions list with changes in POSIX.1-2008.
         SEE ALSO: add proc(5).

signal.7
     mtk
         Update list of async-sygnal-safe functions for POSIX.1-2008.

