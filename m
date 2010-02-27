Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968528Ab0B0Pvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:51:43 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36873 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968435Ab0B0Pvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:51:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=VdeXTQlosiZjgS74euvqpugjdDqUqt80DMRHGO770uCL78diu4/Mb/fbZngo4YGPgJ
         VgfdvfjQYyEHEc7tYFgxWkVNHIL9+JGGiANYNsfAFPevK5e/oScd11nd+xPSquPuR6xV
         pVfwEsdXbq0We2zqJJ25qOrc1qeod/BwnxGnc=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
Date: Sat, 27 Feb 2010 16:51:39 +0100
Message-ID: <cfd18e0f1002270751q56dad24cqecfc582c899fc58f@mail.gmail.com>
Subject: man-pages-3.24 is released
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.24.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/02/man-pages-324-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael


==================== Changes in man-pages-3.24 ====================

Released: 2010-02-25, Munich


New and rewritten pages
-----------------------

add_key.2
    David Howells
        New page documenting add_key(2)
            Taken from keyutils-1.1 package.

keyctl.2
    David Howells
        New page documenting keyctl(2)
            Taken from keyutils-1.1 package.

request_key.2
    David Howells
        New page documenting request_key(2)
            Taken from keyutils-1.1 package.


Changes to individual pages
---------------------------

clock_getres.2
    Michael Kerrisk
        Update text on nonsetabble CLOCK_*_CPUTIME_ID clocks
            SUSv3 permits, but does not require CLOCK_THREAD_CPUTIME_ID and
            CLOCK_PROCESS_CPUTIME_ID to be settable.
            See http://bugzilla.kernel.org/show_bug.cgi?id=11972.

execve.2
    Colin Watson
        Fix description of treatment of caught signals
            Caught signals reset to their default on an execve() (not
            to being ignored).

fcntl.2
    Michael Kerrisk
        s/F_OWNER_GID/F_OWNER_PGRP/
            Peter Zijlstra took the name change I suggested.

fcntl.2
    Michael Kerrisk
        Document F_[SG]ETOWN_EX; update details on F_SETOWN
            Linux 2.6.32 adds F_SETOWN_EX and F_GETOWN_EX.
            Linux 2.6.12 changed (broke) the former behavior of
            F_SETOWN with respect to threads.

setgid.2
    Michael Kerrisk
        Fix EPERM error description
            s/effective group ID/real group ID/
            This bug lived in man pages for 15 years before Jason
            spotted it! I checked back in Linux 1.0, and the behavior
            was as the fixed man page describes.

setreuid.2
    Michael Kerrisk
        Add more detail on POSIX.1 specification for these syscalls

sync_file_range.2
    Christoph Hellwig
        Add some big warnings re data integrity
            This system call is by design completely unsuitable for any data
            integrity operations.  Make that very clear in the manpage.

capabilities.7
    Michael Kerrisk
        Update securebits discussion to use SECBIT_* flags

feature_test_macros.7
    Michael Kerrisk
        _POSIX_C_SOURCE >= 200808 defines _ATFILE_SOURCE
            Since glibc 2.10, _POSIX_C_SOURCE >= 200808 defines _ATFILE_SOURCE

signal.7
    Michael Kerrisk
        Fix discussion of SIGUNUSED
            Clarify that this signal really is synonymous with SIGSYS.
            See http://bugzilla.kernel.org/show_bug.cgi?id=14449

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
