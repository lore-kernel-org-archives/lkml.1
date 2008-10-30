Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYJ3Orr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYJ3Orr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYJ3Ori
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:47:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:24976 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbYJ3Orh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=nvBfHGTIQU95HHkq15O4Pmtloypb1I3U+L84Jjj39lKugFSW4wV1AvK8rDKZmnl0qV
         2JdPh+/dP7gIUNkBbqrGF23uQkUM+mtly3znm4kYlmm+PEAjIzZ0ghA6Lqu1nW5NheAx
         iWV32hxUONxq+4xUHFSX/BuDoxJoqdUbvf5Gc=
Message-ID: <4909C8D5.3080608@gmail.com>
Date: Thu, 30 Oct 2008 09:46:45 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.12 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.12.

This release is now available for download at:

   http://www.kernel.org/pub/linux/docs/man-pages
   or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/10/man-pages-312-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
particular interest to readers of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-3.12 ====================

New and rewritten pages
-----------------------

pthread_attr_init.3
     Michael Kerrisk
         New page for pthread_attr_init(3) and pthread_attr_destroy(3)

pthread_attr_setdetachstate.3
     Michael Kerrisk
         New page for pthread_attr_setdetachstate(3) and
         pthread_attr_getdetachstate(3)

pthread_attr_setguardsize.3
     Michael Kerrisk
         New page for pthread_attr_setguardsize(3) and
         pthread_attr_getguardsize(3)

pthread_attr_setscope.3
     Michael Kerrisk
         New page for pthread_attr_setscope(3) and pthread_attr_getscope(3)

pthread_attr_setstack.3
     Michael Kerrisk
         New page for pthread_attr_setstack(3) and pthread_attr_getstack(3)

pthread_attr_setstackaddr.3
     Michael Kerrisk
         New page for pthread_attr_setstackaddr(3) and
         pthread_attr_getstackaddr(3)

pthread_attr_setstacksize.3
     Michael Kerrisk
         New page for pthread_attr_setstacksize(3) and
         pthread_attr_getstacksize(3)

pthread_create.3
     Michael Kerrisk
         New page describing pthread_create(3)

pthread_detach.3
     Michael Kerrisk
         New page for pthread_detach(3)

pthread_equal.3
     Michael Kerrisk
         New page for pthread_equal(3)

pthread_exit.3
     Michael Kerrisk
         New page describing pthread_exit(3)

pthread_getattr_np.3
     Michael Kerrisk
         New page for pthread_getattr_np(3)

pthread_join.3
     Michael Kerrisk
         New page for pthread_join(3)

pthread_self.3
     Michael Kerrisk
         New page for pthread_self(3)

pthread_tryjoin_np.3
     Michael Kerrisk
         New page for pthread_tryjoin_np(3) and pthread_timedjoin_np(3)


Newly documented interfaces in existing pages
---------------------------------------------

dup.2
     Michael Kerrisk
         Add description of dup3()
             dup3() was added in kernel 2.6.27.

epoll_create.2
     Michael Kerrisk
         Add description of new epoll_create1()
             The new epoll_create1() system call appeared in Linux 2.6.27.
eventfd.2
     Michael Kerrisk
         Describe eventfd2() and EFD_NONBLOCK and EFD_CLOEXEC
             Linux 2.6.27 added eventfd(), which supports a flags argument
             that eventfd() did not provide.  The flags so far implemented
             are EFD_NONBLOCK and EFD_CLOEXEC,

inotify_init.2
     Michael Kerrisk
         Add description of inotify_init1()
             The inotify_init1() system call was added in Linux 2.6.27.

pipe.2
     Michael Kerrisk
         Add description of new pipe2() syscall
             pipe2() was added in 2.6.27.  Describe the O_NONBLOCK and
             O_CLOEXEC flags.

signalfd.2
     Michael Kerrisk
         Describe signalfd4() and SFD_NONBLOCK and SFD_CLOEXEC
             Linux 2.6.27 added signalfd4(), which supports a flags argument
             that signalfd() did not provide.  The flags so far implemented
             are SFD_NONBLOCK and SFD_CLOEXEC.


Changes to individual pages
---------------------------

sched_yield.2
     Michael Kerrisk
         Rewrite description in terms of threads
             The text formerly described the operation of sched_yield() in
             terms of processes.  It should be in terms of threads.
     Michael Kerrisk
         Add NOTES text on appropriate use of sched_yield()
             Strategic calls to sched_yield() can be used to improve
             performance, but unnecessary use should be avoided.

sigaction.2
     Michael Kerrisk
         Clarify that sa_mask affects the *per-thread* signal mask
             The page didn't previously clearly explain the scope of the
             signal mask that is affected by sa_mask.

sigprocmask.2
     Michael Kerrisk
         Clarify that sigprocmask() operates on a per-thread mask
             The first sentence of the page was vague on the scope of the
             attribute changed by sigprocmask().  Reword to make this
             clearer and add a sentence in NOTES to explicitly state that
             the signal mask is a per-thread attribute.

socket.2
     Michael Kerrisk
         Document SOCK_NONBLOCK and SOCK_CLOEXEC flags
             These flags, specified in the 'type' argument, are supported
             since Linux 2.6.27.

socketpair.2
     Michael Kerrisk
         Refer to socket(2) for SOCK_CLOEXEC and SOCK_NONBLOCK
             Refer the reader to socket(2) for a description of the SOCK_CLOEXEC
             and SOCK_NONBLOCK flags, which are supported by socketpair() since
             Linux 2.6.27.

timerfd_create.2
     Michael Kerrisk
         Document timerfd_create() TFD_CLOEXEC and TFD_NONBLOCK
             TFD_CLOEXEC and TFD_NONBLOCK are supported since LInux 2.6.27.

dlopen.3
     Michael Kerrisk
         LD_LIBRARY_PATH is inspected once, at program start-up
             Make it clear that LD_LIBRARY_PATH is inspected *once*, at
             program start-up.  (Verified from source and by experiment.)

getaddrinfo.3
     Michael Kerrisk
         Clarify error descriptions with some examples
             Clarify the description of some errors by giving examples
             that produce the errors.  (Text added for EAI_SERVICE and
             EAI_SOCKTYPE.)

             Also, add an error case for EAI_BADFLAGS.

tty_ioctl.4
     Michael Kerrisk
         Explain capability requirements for TIOCCONS
             Explain capability requirements for TIOCCONS, and describe
             changes in 2.6.10 relating to capabilities.
     Michael Kerrisk
         Explain capability requirements for various ioctls
             For TIOCSLCKTRMIOS, TIOCSCTTY, TIOCEXCL, explain the exact
             capability that is required (the text formerly just said "root"
             in each case).

proc.5
     Michael Kerrisk
         Document /proc/sys/kernel/threads-max
             Defines the system-wide limit on the number of threads (tasks).

utmp.5
     Pierre Cazenave
         It is just "other" who should not have write perms on utmp
             The page was vague before, saying that utmp should not be
             writable by any user.  This isn't true: it can be, and
             typically is, writable by user and group.

ld.so.8
     Michael Kerrisk
         Document LD_USE_LOAD_BIAS
             Drawing heavily on Jakub Jelinek's description in
             http://sources.redhat.com/ml/libc-hacker/2003-11/msg00127.html
             (Subject: [PATCH] Support LD_USE_LOAD_BIAS)
         --inhibit-rpath is ignored for setuid/setgid ld.so
             The --inhibit-rpath option is ignored if ld.so is setuid/setgid
             (not if the executable is setuid/setgid).
     Michael Kerrisk
         Since glibc 2.4, setuid/setgid programs ignore LD_ORIGIN_PATH
     Michael Kerrisk
         Fix description of LD_PROFILE and LD_PROFILE_OUTPUT
             Clarify that LD_PROFILE is pathname or a soname,
             and identify name of profiling output file.
             Fix description of LD_PROFILE_OUTPUT, which wasn't even close to
             the truth.  (But why did it remain unfixed for so many years?)
     Michael Kerrisk
         Since glibc 2.3.4, setuid/setgid programs ignore LD_DYNAMIC_WEAK
     Michael Kerrisk
         Since version 2.3.5, setuid/setgid programs ignore LD_SHOW_AUXV
     Michael Kerrisk
         Reorder lists of LD_* environment variables alphabetically
     Michael Kerrisk
         Since glibc 2.3.4, setuid/setgid programs ignore LD_DEBUG

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
