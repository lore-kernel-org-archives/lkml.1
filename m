Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYLWAbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYLWAbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYLWAbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:31:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39905 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbYLWAbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:31:00 -0500
Date: Tue, 23 Dec 2008 01:30:50 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.14.2-rc1
Message-ID: <20081223003049.GE2930@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first util-linux-ng 2.14.2 release candidate is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/

(Note that 2.14.2 is stable maintenance release.)

Feedback and bug reports, as always, are welcomed.


	Karel


Util-linux-ng 2.14.2 Release Notes
==================================

ChangeLog between v2.14.1 and v2.14.2
-------------------------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.14/

build-sys:
   - add -luuid to BLKID_LIBS  [Karel Zak]
cfdisk:
   - accept yes/no as fallback  [Matthias Koenig]
chrt:
   - support CFS SCHED_IDLE priority and document it  [Martin Steigerwald]
docs:
   - update AUTHORS file  [Karel Zak]
fdisk:
   - add some missing includes  [Matthias Koenig]
   - cannot create partition with starting beyond 1 TB  [Karel Zak]
   - fix man page typo  [Karel Zak]
   - remove obsolete information from man page  [Karel Zak]
   - remove unnecessary gettext call  [Karel Zak]
   - several strings without gettext calls  [Pedro Ribeiro]
   - support +cylinder notation  [Karel Zak]
hwclock:
   - remove "cli" and "sti" from i386 CMOS code  [Karel Zak]
   - remove x86_64-specific bogon  [David Brownell]
include:
   - use __BYTE_ORDER rather than AC specific WORDS_BIGENDIAN  [Karel Zak]
ldattach:
   - don't compile for non-linux systems  [Samuel Thibault]
lib:
   - add __BYTE_ORDER to md5.c  [Karel Zak]
logger:
   - several strings without gettext calls  [Pedro Ribeiro]
login:
   - fix compiler warning (int32 time() arg)  [Karel Zak]
   - fix warning "dereferencing type-punned pointer will break strict-aliasing rules"  [Karel Zak]
losetup:
   - add warning about read-only mode  [Karel Zak]
   - missing EBUSY error hint message  [Karel Zak]
   - several strings without gettext strings  [Pedro Ribeiro]
   - try to set up loop readonly if EACCES  [Matthias Koenig]
mkfs.cramfs:
   - several strings without gettext calls  [Pedro Ribeiro]
mkfs.minix:
   - fix size detection  [Matthias Koenig]
more:
   - dont use a.out.h  [Mike Frysinger]
   - minor fixes to magic()  [James Youngman]
mount:
   - add i_version support  [Karel Zak]
   - add info about /proc/mounts to mount.1  [Karel Zak]
   - add rootcontext= SELinux mount option  [Karel Zak]
   - clean up SPEC canonicalization  [Karel Zak]
   - create separate section for fs-independent options in mount.8  [Karel Zak]
   - fix mount_static_LDADD  [Karel Zak]
   - fix typo  [Guan Xin]
   - fix typo  [Karel Zak]
   - make file_t SELinux warning optional and shorter  [Karel Zak]
   - mtab created multiple times with -a option  [Karel Zak]
   - remove link to namesys.com  [Karel Zak]
   - remove spurious newline from mount.8  [Mike Frysinger]
   - reorder list of options in mount.8  [Karel Zak]
   - retry on ENOMEDIUM  [Matthias Koenig]
   - sundries.h add klibc support  [maximilian attems]
   - sync FAT info in mount.8 with Documentation/filesystems/vfat.txt  [Karel Zak]
   - sync tmpfs info in mount.8 with Documentation/filesystems/tmpfs.txt  [Karel Zak]
   - use subsections in mount.8 DESCRIPTION  [Karel Zak]
   - warn on "file_t" selinux context  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update cs.po (from translationproject.org)  [Petr Pisar]
   - update fr.po (from translationproject.org)  [Nicolas Provost]
   - update pt_BR.po (from translationproject.org)  [Rodrigo Stulzer Lopes]
   - update sv.po (from translationproject.org)  [Daniel Nylander]
readprofile:
   - several strings without gettext calls  [Pedro Ribeiro]
setterm:
   - fix -blank man page  [Karel Zak]

- use getpagesize()  [maximilian attems]

-- 
 Karel Zak  <kzak@redhat.com>
