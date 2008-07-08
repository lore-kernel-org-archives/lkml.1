Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYGHPvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYGHPvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYGHPve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:51:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:1536 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbYGHPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=QUtD5fGPK7h+IuEM+YuqMHqCsBrOmuD+NEaZbb5EWLZiFVjcJXcW+7oEpNWLmQ8S9S
         rYWpgYH1lEB8rzZSIVhfBliD7zPXHWI+QeVjD98yUcfsjJ06usxbdL4Xow6geS2tZxw5
         TLxgxrgEEFSnYEPadGnT0E1SNjbk3dTYPCuVw=
Message-ID: <48738C24.8020308@gmail.com>
Date: Tue, 08 Jul 2008 17:47:48 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.03 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.03.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/07/man-pages-303-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-3.03 ====================


New and rewritten pages
-----------------------

getcpu.2
     Andi Kleen, with some text and edits by mtk
         Documents the getcpu(2) system call, introduced in Linux 2.6.19.

sched_getcpu.3
     mtk
         Documents sched_getcpu(3), a wrapper for getcpu(2), provided
         since glibc 2.6.

cpuset.7
     Paul Jackson, with review and editing by mtk, and comments by
     Hidetoshi Seto and Li Zefan
         A description of the cpuset file system, the mechanism introduced
         kernel 2.6.12 for confining processes to designated processors
         and nodes.  (Becomes the fourth largest page in man-pages!)


Changes to individual pages
---------------------------

signal.7
     mtk
         Add a section describing system call restarting, and noting
         which system calls are affected by SA_RESTART, and which
         system calls are never restarted.
     mtk
         Describe the aberrant Linux behavior whereby a stop signal
         plus SIGCONT can interrupt some system calls, even if no
         signal handler has been established, and note the system
         calls that behave this way.

