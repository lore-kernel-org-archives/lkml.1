Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYFQLhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYFQLhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 07:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYFQLh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 07:37:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:21233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYFQLhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 07:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=HkS/cSx/Uzxx2IObtecjC3JgTedoVZ5Pd7ka8128gCzk6kxzeo0Kh4qchm9FQHCdRX
         CQON3qFvaTHjdIB6l0dOpQ/u5a+pUvJNKUfn2+wXCmMyGzpMhFePDQh8/pNQzW3jy7ir
         ZAc5XS5z8Vg0Sui+gXSdo9F3D3bN0qYWJZDPA=
Message-ID: <4857A1C7.10100@gmail.com>
Date: Tue, 17 Jun 2008 13:36:39 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Jim Zemlin <jzemlin@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       tech-board@lists.linux-foundation.org
Subject: [patch] man-pages is supported
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Could you please apply the following.

Starting last month, I reached a long-time goal: man-pages finally has a paid,
full-time maintainer, thanks to a fellowship from the Linux Foundation.  It's
still a little unclear how long the LF money will last for the fellowship, but
for the foreseeable future, I'll be working on:

* Properly documenting every new Linux kernel-userland (and glibc) API, and
every API change, that is released into the mainline kernel, ideally before
actual release.  (That's the ideal, but there's a quite a backlog, so I'm not
going to achieve the ideal immediately.)
* Testing new APIs, again ideally before they are released into the mainline
kernel, and probably doing some light bug fixing while I'm at it (e.g., the
recent utimensat() work).
* Design review of new APIs, which of course can only usefully be done before
they are released into the mainline kernel.
* And of course accepting patches and dealing with bug reports for existing
man pages.

Cheers,

Michael

--- linux-2.6.26-rc5/MAINTAINERS.old    2008-06-09 10:36:14.000000000 +0200
+++ linux-2.6.26-rc5/MAINTAINERS        2008-06-09 10:37:27.000000000 +0200
@@ -2680,8 +2680,8 @@
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:     Michael Kerrisk
 M:     mtk.manpages@gmail.com
-W:     ftp://ftp.kernel.org/pub/linux/docs/manpages
-S:     Maintained
+W:     http://www.kernel.org/doc/man-pages
+S:     Supported

 MARVELL LIBERTAS WIRELESS DRIVER
 P:     Dan Williams



