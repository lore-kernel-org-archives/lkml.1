Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYKKTQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYKKTQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYKKTQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:16:28 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:8917 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYKKTQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:16:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=Qj6MYG/3hduT9qifbUpYJRN9oHe6VYDUGdm78TbL+my6hx/W7EgrMDWnkbJMd6C+wI
         6ZyMHP76JtEKzokegrDgi56lyle7EGQj78OGc2fMKpfJyrGCKc8+3RTU6xZpKRTLvhO+
         BXA0ljSR1ciWsI+5epm9QxTg0vr88kR3Nlo2k=
Message-ID: <4919DA05.4010809@gmail.com>
Date: Tue, 11 Nov 2008 14:16:21 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.13 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.13.

This release is now available for download at:

   http://www.kernel.org/pub/linux/docs/man-pages
   or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/11/man-pages-313-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
particular interest to readers of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-3.13 ====================

New and rewritten pages
-----------------------

pthread_attr_setaffinity_np.3
     Michael Kerrisk
         New page for pthread_attr_setaffinity_np(3) and
         pthread_attr_getaffinity_np(3)

pthread_attr_setschedparam.3
     Michael Kerrisk
         New page for pthread_attr_setschedparam(3) and
         pthread_attr_getschedparam(3)

pthread_attr_setschedpolicy.3
     Michael Kerrisk
         New page for pthread_attr_setschedpolicy(3) and
         pthread_attr_getschedpolicy(3)

pthread_setaffinity_np.3
     Michael Kerrisk
         New page for pthread_setaffinity_np(3) and pthread_getaffinity_np(3)

pthread_setschedparam.3
     Michael Kerrisk
         New page for pthread_setschedparam(3) and pthread_getschedparam(3)

pthread_setschedprio.3
     Michael Kerrisk
         New page for pthread_setschedprio(3)


Changes to individual pages
---------------------------

clock_getres.3
     Michael Kerrisk
         CLOCK_PROCESS_CPUTIME_ID and CLOCK_THREAD_CPUTIME_ID not setabble
             According to POSIX.1-2001, the CLOCK_PROCESS_CPUTIME_ID and
             CLOCK_THREAD_CPUTIME_ID clocks should be settable, but
             currently they are not.

pthread_exit.3
     Michael Kerrisk
         BUGS: thread group with a dead leader and stop signals
             Document the bug that can occur when a stop signal
             is sent to a thread group whose leader has terminated.
             http://thread.gmane.org/gmane.linux.kernel/611611
             http://marc.info/?l=linux-kernel&m=122525468300823&w=2

epoll.7
     Michael Kerrisk
         Fix error handling after accept() in example code
             Simply continuing after an error is in most cases wrong,
             and can lead to infinite loops (e.g., for EMFILE).
             So handle an error by terminating.
             http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=504202
         Add error handling for epoll_wait() call in example code
         Improve example code
             Fill in some gaps in example code (variable declarations,
             adding listening socket to epoll set).
             Give variables more meaningful names.
             Other minor changes.
             http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=504202

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

