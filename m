Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbXJHTyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbXJHTyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXJHTyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:54:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:49931 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752751AbXJHTyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:54:32 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+jzYlhzQ+jeTt2LNh1x7/LOU3JKSe/+5UU1W8Lr2
	Ph8SdFY8iS+GZK
Message-ID: <470A8A4E.3020301@gmx.net>
Date: Mon, 08 Oct 2007 21:51:42 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.66 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

Some news: the list linux-man@vger.kernel.org has been created for the
purpose of discussing Linux man page bugs, patches, and maintenance.  To
subscribe, send a message to majordomo@vger.kernel.org, with the body:

    subscribe linux-man

Back to the news as usual...

I recently released man-pages-2.66.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

Changes in this release that may be of interest to readers of this list are
noted below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

==================== Changes in man-pages-2.66 ====================

New pages
---------

fallocate.2
    David Chinner, with some input from Amit Amora and mtk
       Describes the fallocate() system call, new in 2.6.23.


Changes to individual pages
---------------------------

close.2
    Fredrik Noring
        Add text cautioning about use of close() in
        multithreaded programs.

execve.2
    Ollie Wild / mtk
        Add text describing limit on total size of argv + envp,
        and changes that occurred with 2.6.23.

open.2
    mtk, Acked by Ulrich Drepper
        Added description of O_CLOEXEC (new in 2.6.23) + other
        minor fixes for O_DIRECT.

recv.2
    mtk
        Added description of MSG_CMSG_CLOEXEC (new in 2.6.23).

sysctl.2
    mtk
        Strengthened the warning against using this system call
        and note that it may disappear in a future kernel version.


