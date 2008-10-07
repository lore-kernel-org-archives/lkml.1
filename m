Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYJGJuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYJGJuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYJGJup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:50:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:36031 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYJGJuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mZnueDZvdMUObn26Cqrx9LoF267FSQxTWn1HkQyAfP96e9D68zbK068CIo7g4TOYcP
         CgTR7zzZtrb514n6xYz0Phu/igyTIEPTee36cbTvhldlOpB823gfHkaLzTv+tDesDhLa
         KLx2Wx96ksacDYjUYdZWloxZNfMdVAfb9smDE=
Message-ID: <cfd18e0f0810070250l5375900bxe80b15192f9e331b@mail.gmail.com>
Date: Tue, 7 Oct 2008 11:50:43 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: man-pages-3.11 is released
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.10.

This release is now available for download at:

  http://www.kernel.org/pub/linux/docs/man-pages
  or ftp://ftp.kernel.org/pub/linux/docs/man-pages

(The very latest version of man-pages is always available via git, at
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git .)

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/10/man-pages-311-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
particular interest to readers of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-3.11 ====================

New and rewritten pages
-----------------------

umount.2
    Michael Kerrisk
        Create a new page for umount() and umount2() by extracting
        existing material from mount.2 page.


Changes to individual pages
---------------------------

getdents.2
    Michael Kerrisk
        getdents.2: Add an example program
        getdents.2: comment out linux_dirent fields with varying location
        getdents.2: The DT_* constants are defined in <dirent.h>
        getdents.2: remove header files from SYNOPSIS
        getdents.2: The programmer must define the linux_dirent structure
        getdents.2: s/dirent/linux_dirent/

mount.2
    Michael Kerrisk
        mount.2: Add description of per-process namespaces
        mount.2: Document MS_SILENT (and MS_VERBOSE)

signal.7
    Michael Kerrisk
        signal.7: improve description in NAME section
        signal.7: Add mention of sigaltstack(2).
        signal.7: Describe syscalls that synchronously wait for a signal,
        signal.7: Give overview of syscalls that block until a signal is caught
        signal.7: Add overview of interfaces for sending signals.
        signal.7: describe semantics w.r.t. fork() and execve()

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
