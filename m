Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZJCGGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZJCGGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 02:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZJCGG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 02:06:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:8365 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZJCGG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 02:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=Q9hBMBMXXeF7LLYFbRJ6rtfZxbv5RR6hbqF8ruAMZIE9AVnm9m/eTY4gKc+nrG7tIx
         mP/5mtp2aUp2R7PAR9jepYJRqEutr8sXWk7ABBDF9Qasn3cb7vUQh/KP8Ga04JN9MJWr
         WHL0qqNZKbMN0erODZxYQA34Ss9Gnt406rpaE=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
Date: Sat, 3 Oct 2009 08:06:32 +0200
Message-ID: <cfd18e0f0910022306x2b5fd7ccief4422b145ef051e@mail.gmail.com>
Subject: man-pages-3.23 is released
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.23.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/10/man-pages-323-release-my-book.html )
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

This release consists entirely of fixes to existing pages. An abridged
list changes that may be of interest to readers of this list is
provided below.

Cheers,

Michael

==================== Changes in man-pages-3.23 ====================

Released: 2009-09-30, Munich


getrusage.2
    Michael Kerrisk
        ru_inblock and ru_oublock are now implemented
            These fields of the rusage structure are filled in since
            Linux 2.6.22.

mmap.2
    Michael Kerrisk
        Add brief documentation of MAP_HUGETLB
            This flag is new in 2.6.32, and serves a similar
            purpose to the shmget() SHM_HUGETLB flag.

open.2
    Christoph Hellwig
        add some comments on O_SYNC and friends

splice.2
tee.2
vmsplice.2
    Mark Hills
        Fix return type
            Since glibc 2.7, the return type for these functions
            is ssize_t (formerly it was long).

mq_overview.7
    Michael Kerrisk
        Change documented ranges for msg_max and msgsize_max
            Linux 2.6.28 changed the permissible ranges for
            these /proc files.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
