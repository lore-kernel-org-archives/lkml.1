Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbXJVOpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbXJVOpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXJVOp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:45:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:35838 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXJVOp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=lJHYT0d9+GyLMuch5oir+5TTAJw1yg1AgM3iUUd0gNwYBfhz9ujAgEKvwE6OIRGrxE0cpB3/f1wgA3f00YHNTQgcXAYOrB1QFpTiv94SuLAKLdoxpPgia2MzqKmBIx02bcUVbyFp1BiDkNynG/c9dOG18aT7H1vgm4IdhG5OGAk=
Message-ID: <471CB844.6020105@gmail.com>
Date: Mon, 22 Oct 2007 16:48:36 +0200
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: linux-man@vger.kernel.org
Subject: man-pages-2.67 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

Some news: as from now, my address as man-pages maintainer has changed to
mtk.manpages@gmail.com.  (Mail to the old address will continue to work for
a while, but eventually I will close that account.)

Some older news: the list linux-man@vger.kernel.org has been created for
the purpose of discussing Linux man page bugs, patches, and maintenance.
To subscribe, send a message to majordomo@vger.kernel.org, with the body:

    subscribe linux-man

Back to the news as usual...

I recently released man-pages-2.67.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

The changes in this release are primarily formatting fixes, and the
addition of a PROLOG section to the 1p and 3p (POSIX) pages giving a clear
indication that these are POSIX man pages (so as to prevent readers wrongly
understanding that they are looking at a description of Linux behavior).

There are many things to be fixed in the man pages.  Help with any of the
problems listed below would be greatly appreciated.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

=========================================================================

FIXMEs

==========
./man2/futex.2
     FIXME
     2.6.18 adds (Ingo Molnar) priority inheritance support:
     FUTEX_LOCK_PI, FUTEX_UNLOCK_PI, and FUTEX_TRYLOCK_PI.  These need
     to be documented in the manual page.  Probably there is sufficient
     material in the kernel source file Documentation/pi-futex.txt.

==========
./man2/ioperm.2
     FIXME is the following ("Only the first 0x3ff I/O ports can be
     specified in this manner") still true?  Looking at changes in
     include/asm-i386/processor.h between 2.4 and 2.6 suggests
     that the limit is different in 2.6.

==========
./man2/mount.2
     FIXME 2.6.15 added flags for "shared sub-tree" functionality:
     MS_UNBINDABLE, MS_PRIVATE, MS_SHARED, MS_SLAVE
     These need to be documented on this page.
     See Documentation/sharedsubtree.txt

     FIXME Say more about MS_MOVE

     FIXME Document MS_REC, available since 2.4.11.
     This flag has meaning in conjunction with MS_BIND and
     also with the shared sub-tree flags.

     FIXME Can MNT_FORCE result in data loss?  According to
     the Solaris manual page it can cause data loss on Solaris.
     If the same holds on Linux, then this should be documented.

==========
./man2/mprotect.2
     FIXME
     Document PROT_GROWSUP and PROT_GROWSDOWN

==========
./man2/nfsservctl.2
     FIXME The description of nfsservctl() on this page
     is woefully thin.

==========
./man2/quotactl.2
     FIXME There is much that is missing and/or out of date in this page.
     As things stand the page more or less documents Linux 2.2 reality:

     Linux 2.2 has:

        Q_GETQUOTA
        Q_GETSTATS
        Q_QUOTAOFF
        Q_QUOTAON
        Q_RSQUASH (not currently documented)
        Q_SETQLIM
        Q_SETQUOTA
        Q_SETUSE
        Q_SYNC

     Linux 2.4 has:

        Q_COMP_QUOTAOFF
        Q_COMP_QUOTAON
        Q_COMP_SYNC
        Q_GETFMT
        Q_GETINFO
        Q_GETQUOTA
        Q_QUOTAOFF
        Q_QUOTAON
        Q_SETINFO
        Q_SETQUOTA
        Q_SYNC
        Q_V1_GETQUOTA Q_V1_GETSTATS Q_V1_RSQUASH Q_V1_SETQLIM
        Q_V1_SETQUOTA Q_V1_SETUSE
        Q_V2_GETINFO Q_V2_GETQUOTA Q_V2_SETFLAGS Q_V2_SETGRACE
        Q_V2_SETINFO Q_V2_SETQUOTA Q_V2_SETUSE
        Q_XGETQSTAT Q_XGETQUOTA Q_XQUOTAOFF Q_XQUOTAON Q_XQUOTARM
        Q_XSETQLIM

     Linux 2.6.16 has:

        Q_GETFMT
        Q_GETINFO
        Q_GETQUOTA
        Q_QUOTAOFF
        Q_QUOTAON
        Q_SETINFO
        Q_SETQUOTA
        Q_SYNC
        Q_XGETQSTAT
        Q_XGETQUOTA
        Q_XQUOTAOFF
        Q_XQUOTAON
        Q_XQUOTARM
        Q_XQUOTASYNC
        Q_XSETQLIM

==========
./man2/shmop.2
     FIXME A good explanation of the rationale for the existence
     of SHMLBA would be useful here

     FIXME That last sentence isn't true for all Linux
     architectures (i.e., SHMLBA != PAGE_SIZE for some architectures)
     -- MTK, Nov 04

==========
./man2/sigaction.2
     FIXME si_tid and si_overrun are not documented.
     FIXME si_trapno is not documented; is it actually used?

==========
./man5/acct.5
     FIXME this page needs to say a lot more, including mentioning
        Version 3 format process accounting on Linux.

==========
./man5/proc.5
     FIXME 2.6.14 has /proc/PID/numa_maps (if CONFIG_NUMA is
     enabled); this needs to be documented.
     Info on numa_maps can be found in the patch-2.6.14
     Changelog, but this is possibly not up to date.

     FIXME 2.6.13 seems to have /proc/vmcore implemented
     in the source code, but there is no option available under
     'make xconfig'; eventually this should be fixed, and then info
     from the patch-2.6.13 and change log could be used to write an
     entry in this man page.

     FIXME cross check against Documentation/filesystems/proc.txt
     to see what information could be imported from that file
     into this file.

     FIXME Describe /proc/[number]/loginuid
           Added in 2.6.11; updating requires CAP_AUDIT_CONTROL

     FIXME Describe /proc/[number]/mountstats and
           /proc/PID/task/TID/mountstats
          Some information can be found in the 2.6.17-rc1 change log.
           Added in 2.6.17

     FIXME Describe /proc/[number]/oom_adj
           Added in 2.6.11; updating requires CAP_SYS_RESOURCE
           Mention OOM_DISABLE (-17)
     FIXME Describe /proc/[number]/oom_score
           Added in 2.6.11; read-only

     FIXME Describe /proc/[number]/seccomp
           Added in 2.6.12

     FIXME Document /proc/config.gz (new in kernel 2.6)

     FIXME Actually, the following info abut the /proc/stat 'cpu' field
           does not seem to be quite right (at least in 2.6.12)

     FIXME The following is not the full picture for the 'intr' of
           /proc/stat on 2.6:

     FIXME more should be said about /proc/zoneinfo

==========
./man7/capabilities.7
     FIXME CAP_KILL also has an effect for threads + setting child
           termination signal to other than SIGCHLD: without this
           capability, the termination signal reverts to SIGCHLD
           if the child does an exec().  What is the rationale
           for this?

     FIXME CAP_SETUID also an effect in exec(); document this.

     FIXME CAP_SYS_NICE also has the following effect for
     migrate_pages(2):
         do_migrate_pages(mm, &old, &new,
             capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);

==========
./man7/ipv6.7
     FIXME IPV6_CHECKSUM is not documented, and probably should be
     FIXME IPV6_JOIN_ANYCAST is not documented, and probably should be
     FIXME IPV6_LEAVE_ANYCAST is not documented, and probably should be
     FIXME IPV6_V6ONLY is not documented, and probably should be
     FIXME IPV6_RECVPKTINFO is not documented, and probably should be
     FIXME IPV6_2292PKTINFO is not documented, and probably should be
     FIXME there are probably many other IPV6_* socket options that
     should be documented

==========
./man7/locale.7
     FIXME glibc 2.2.2 added new non-standard locale categories:
     LC_ADDRESS, LC_IDENTIFICATION, LC_MEASUREMENT, LC_NAME,
     LC_PAPER, LC_TELEPHONE.  These need to be documented.

==========
./man7/netlink.7
     FIXME More details on NETLINK_INET_DIAG needed.

     FIXME More details on NETLINK_XFRM needed.

     FIXME More details on NETLINK_ISCSI needed.

     FIXME More details on NETLINK_AUDIT needed.

     FIXME More details on NETLINK_FIB_LOOKUP needed.

     FIXME More details on NETLINK_NETFILTER needed.

     FIXME More details on NETLINK_KOBJECT_UEVENT needed.

     FIXME NLM_F_ATOMIC is not used any more?

     FIXME Explain more about nlmsg_seq and nlmsg_pid.

==========
./man7/socket.7
     FIXME Document SO_PASSSEC, added in 2.6.18; there is some info
     in the 2.6.18 ChangeLog

==========
./man7/tcp.7
     FIXME 2.6.17-rc1 adds the following /proc files, which need to be
          documented: tcp_mtu_probing, tcp_base_mss, and
          tcp_workaround_signed_windows

     FIXME As at Sept 2006, kernel 2.6.18-rc5, the following are
        not yet documented (shown with default values):

         /proc/sys/net/ipv4/tcp_congestion_control (since 2.6.13)
         bic
         /proc/sys/net/ipv4/tcp_moderate_rcvbuf
         1
         /proc/sys/net/ipv4/tcp_no_metrics_save
         0

     FIXME Document TCP_CONGESTION (new in 2.6.13)

==========
./man7/udp.7
     FIXME document UDP_ENCAP (new in kernel 2.5.67)



