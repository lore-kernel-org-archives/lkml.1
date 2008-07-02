Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYGBTQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYGBTQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYGBTQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:16:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38952 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYGBTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=q3BUNGEr3R9qCaC8mPDf8T4NUdFkitA6KhI5b4JCcUejEjM9rflYdrT/zewFMxED8N
         yjQVBbIYup1A/FxKhU1K6tYCYww9oc0c7fgWMLWZYo7Q+m1IhhLeT8mtud783MDAN/uK
         UdMypXaGU/tWNmzwoWdmvV6P3zCnQxaHTY2aY=
Message-ID: <486BD31E.8050602@gmail.com>
Date: Wed, 02 Jul 2008 21:12:30 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.02 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.02.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/07/man-pages-302-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-3.02 ====================

New and rewritten pages
-----------------------

clock_nanosleep.2
     mtk
         A description of the clock_nanosleep() system call,
         which was added in kernel 2.6.

getgrouplist.3
     mtk
         A near complete rewrite, including additional information and
         a new example program.

gnu_get_libc_version.3
     mtk
         Documents gnu_get_libc_version(3) and gnu_get_libc_release(3).

sigwait.3
     mtk
         Documents sigwait(3).

shm_overview.7
     mtk
         An overview of the POSIX shared memory API.


Changes to individual pages
---------------------------

sigreturn.2
     mtk
         Added a bit more detail on what sigreturn() actually does.

sigwaitinfo.2
     mtk
         Describe behavior when multiple threads are blocked in
         sigwaitinfo()/sigtimedwait().
         SEE ALSO: Add sigwait(3).

utmp.5
     mtk
         Add discussion of POSIX.1 utmpx specification.
         Provide a little more detail on fields of utmp structure.
         Added comments to macros for ut_type field.

signal.7
     mtk
         Note that the delivery order of multiple pending standard
         signals is unspecified.

