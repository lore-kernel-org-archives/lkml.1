Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYKZDn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYKZDn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYKZDm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:42:59 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:39981 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYKZDm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=am54Itbo+CRTZ0xnkso47QqW/GvfReNCo7Kx71jSs/lLDJ/GhBrE3lb7xjcmM1Jhxd
         Mp/cIPl9WJ4h3wPhYIlnEkhP2N/EkfTsrSSKY+b/Xkam0m7lPrvroA7i7rJEnKU81TDk
         KX+3nszQ6mtjT1f9fp7BXGlTFG7TQf2zQCCkg=
Message-ID: <492CC5B6.5040706@gmail.com>
Date: Tue, 25 Nov 2008 22:42:46 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.14 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.14.tar.gz - man pages for Linux

This release is now available for download at:

  http://www.kernel.org/pub/linux/docs/man-pages
  or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

  git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/11/man-pages-314-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

Cheers,

Michael



==================== Changes in man-pages-3.14 ====================


New and rewritten pages
-----------------------

CPU_SET.3
    Michael Kerrisk
        New page documenting CPU_* macros
            This page contains material moved out of sched_setscheduler(2).
            It overwrites a previously existing link file with the same name.

pthread_attr_setinheritsched.3
    Michael Kerrisk
        New page for pthread_attr_setinheritsched(3) and
        pthread_attr_getinheritsched(3)

pthread_cancel.3
    Michael Kerrisk
        New page for pthread_cancel(3)

pthread_cleanup_push.3
    Michael Kerrisk
        New page for pthread_cleanup_push(3) and pthread_cleanup_pop(3)

pthread_setcancelstate.3
    Michael Kerrisk
        New page for pthread_setcancelstate(3) and pthread_setcanceltype(3)

pthread_testcancel.3
    Michael Kerrisk
        New page for pthread_testcancel(3)


Newly documented interfaces in existing pages
---------------------------------------------

clone.2
    Jens Axboe
        Document CLONE_IO (new in Linux 2.6.25)
            Some text also by mtk.
    Michael Kerrisk
        Document CLONE_NEWNET
    Michael Kerrisk
        Document CLONE_NEWUTS (new in Linux 2.6.19)
    Michael Kerrisk
        Document CLONE_NEWIPC flag (new in Linux 2.6.19)
    Michael Kerrisk
        Document CLONE_NEWPID flag (new in Linux 2.6.24)

mmap.2
    Michael Kerrisk
        Document MAP_STACK flag (new in Linux 2.6.27)

arp.7
    Michael Kerrisk
        Document /proc file retrans_time_ms (new in Linux 2.6.12)
    Michael Kerrisk
        Document /proc file base_reachable_time_ms (new in Linux 2.6.12)

icmp.7
    Michael Kerrisk
        Document icmp_ignore_bogus_error_responses (new in Linux 2.2)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document icmp_ratelimit and icmp_ratemask (new in Linux 2.4.10)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document icmp_echo_ignore_broadcasts (new in Linux 2.6.12)
            Text taken from Documentation/networking/ip-sysctl.txt

tcp.7
    Michael Kerrisk
        Document /proc file tcp_slow_start_after_idle (new in Linux 2.6.18)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_base_mss (new in Linux 2.6.17)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_frto_response (new in Linux 2.6.22)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_moderate_rcvbuf (new in Linux 2.4.17/2.6.7)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_congestion_control (new in Linux 2.4.13)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_no_metrics_save (new in Linux 2.6.6)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_mtu_probing (new in Linux 2.6.17)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_dma_copybreak (new in Linux 2.6.24)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_tso_win_divisor (new in Linux 2.6.9)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_allowed_congestion_control (new in Linux 2.4.20)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_workaround_signed_windows (new in Linux 2.6.26)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_available_congestion_control (new in Linux 2.4.20)
            Text taken from Documentation/networking/ip-sysctl.txt
    Michael Kerrisk
        Document /proc file tcp_abc (new in Linux 2.6.15)
            Text taken from Documentation/networking/ip-sysctl.txt

udp.7
    Michael Kerrisk
        Document /proc files udp_mem, udp_rmem_min, and udp_wmem_min
            All of these are new in Linux 2.6.25


Changes to individual pages
---------------------------

sysctl.2
    Michael Kerrisk
        Add prominent warning against using this system call
            This was already stated under NOTES, but make it even more
            prominent by adding a sentence at the start of the DESCRIPTION.

clock_getres.3
    Michael Kerrisk
        CLOCK_PROCESS_CPUTIME_ID and CLOCK_THREAD_CPUTIME_ID not settable
            According to POSIX.1-2001, the CLOCK_PROCESS_CPUTIME_ID and
            CLOCK_THREAD_CPUTIME_ID clocks should be settable, but
            currently they are not.

makecontext.3
    Michael Kerrisk
        Add text on use of pointer arguments to makecontext()
            Passing pointer arguments to makecontext() is possible,
            but only on some architectures, and with no guarantees
            of portability.

            http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=504699

syslog.3
    Masanari Iida
        LOG_KERN messages can't be generated from user processes
            Masanari notes that this is an FAQ for logger(1) and that
            Solaris and FreeBSD document this point in syslog(3).
            The glibc info page also hides this comment in its source:

                Internally, there is also LOG_KERN, but LOG_KERN == 0,
                which means if you try to use it here, just selects default.

tcp.7
    Michael Kerrisk
        Update description of tcp_rmem defaults for Linux 2.6
    Michael Kerrisk
        The tcp_bic* proc files disappeared in Linux 2.6.13
    Michael Kerrisk
        tcp_vegas_cong_avoid disappeared in Linux 2.6.13
    Michael Kerrisk
        Clarify that tcp_mem measures in units of the system page size
    Michael Kerrisk
        Update tcp_frto description for 2.6.22 changes
            Linux 2.6.22 added a mode value 2 ("Enable SACK-enhanced
            F-RTO if flow uses SACK").
    Michael Kerrisk
        tcp_westwood /proc file disappeared in Linux 2.6.13
    Michael Kerrisk
        Update description of tcp_wmem defaults for Linux 2.6
