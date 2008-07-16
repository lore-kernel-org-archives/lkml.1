Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbYGPOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbYGPOip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYGPOii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:38:38 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:36360 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYGPOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=k1pof3sMJind5TfnIRiN3WRlJjY87hvkU6fiWAiTGYAGb6YOlNk8UMamSDLx42kb7P
         IByAnXxYG3qiHe2/NfYzRWLNs3oRZn/uqoofcPErQaeX9B/vT5Ckz73BZ21OPC+/1yGd
         gKsbd/sKf4QzsqsQPQ2JriR6revCNaeD0lKC4=
Message-ID: <487E0706.70107@gmail.com>
Date: Wed, 16 Jul 2008 16:34:46 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.04 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.04.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/07/man-pages-304-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-3.04 ====================

Web site
--------

licenses.html
     mtk
         A page describing the preferred licenses for new pages that
         are contributed to man-pages.


New and rewritten pages
-----------------------

utimensat.2
     mtk
         New page documenting the utimensat() system call, new in 2.6.22,
         and futimens() library function.

end.3
     mtk
         Documents etext, edata, and end symbols.


Newly documented interfaces in existing pages
---------------------------------------------

proc.5
     mtk
         Document /proc/config.gz (new in kernel 2.6).
     mtk, based on text from Documentation/vm/sysctl.txt
         Document /proc/sys/vm/oom_kill_allocating_task
         (new in Linux 2.6.24).
         Document /proc/sys/vm/oom_dump_tasks
         (new in Linux 2.6.25).
         Document /proc/sys/vm/panic_on_oom
         (new in Linux 2.6.18).


Changes to individual pages
---------------------------

capget.2
     Andrew Morgan
         Update in line with addition of file capabilities and
         64-bit capability sets in kernel 2.6.2[45].

getrusage.2
     Sripathi Kodi
         Document RUSAGE_THREAD, new in 2.6.26.

mount.2
     mtk
         Since Linux 2.6.26, MS_RDONLY honors bind mounts.

prctl.2
     Serge Hallyn, with some edits/input from mtk
         Document PR_CAPBSET_READ and PR_CAPBSET_DROP.
     Erik Bosman
         Document PR_GET_TSC and PR_SET_TSC.
     mtk, reviewed by Andrea Arcangeli
         Document PR_SET_SECCOMP and PR_GET_SECCOMP.
     mtk
         Add description of PR_SET_SECUREBITS and PR_GET_SECUREBITS,
         as well as pointer to further info in capabilities(7).

sigaction.2
     mtk
         Document si_overrun and si_tid fields of siginfo structure.

signal.2
     mtk
         Rewrote and expanded portability discussion.

getopt.3
     mtk
         Add details on initial value of optind, and note that it can
         be reset (to 1) to restart scanning of an argument vector.
         Add a NOTES section describing the glibc-specific behavior
         when optind is reset to 0 (rather than 1).
         See http://groups.google.com/group/comp.unix.programmer/browse_thread/thread/be0d0b7a07a165fb
     mtk
         Note glibc extensions under CONFORMING TO.

tty_ioctl.4
     mtk / Petr Gajdos
         The features in the "Get and Set Window Size" subsection
         require the inclusion of <sys/ioctl.h>.

capabilities.7
     Serge Hallyn, plus a bit of work by mtk
         Document file capabilities, per-process capability bounding set,
         changed semantics for CAP_SETPCAP, and other changes in 2.6.2[45].
         Add CAP_MAC_ADMIN, CAP_MAC_OVERRIDE, CAP_SETFCAP.
         Various smaller fixes.
     mtk, plus review by Serge Hallyn and Andrew Morgan
         Add text detailing how CAP_SETPCAP (theoretically) permits -- on
         pre-2.6.25 kernels, and 2.6.25 and later kernels with file
         capabilities disabled -- a thread to change the capability sets
         of another thread.
         Add section describing rules for programmatically adjusting
         thread capability sets.
         Add some words describing purpose of inheritable set.
         Note existence of CONFIG_SECURITY_CAPABILITIES config option.
         Describe rationale for capability bounding set.
         Document securebits flags (new in 2.6.26).
     mtk
         Add text noting that if we set the effective flag for one
         file capability, then we must also set the effective flag for all
         other capabilities where the permitted or inheritable bit is set.


