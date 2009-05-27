Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZE0U4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZE0U4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZE0U4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:56:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60228 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbZE0U4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:56:23 -0400
Date: Wed, 27 May 2009 22:56:22 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.15.1-rc1
Message-ID: <20090527205621.GH11402@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first util-linux-ng 2.15.1 release candidate is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/

Feedback and bug reports, as always, are welcomed.

	Karel


Util-linux-ng 2.15.1 Release Notes
==================================

Changes since v2.15
-------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.15/

build-sys:
   - add UTIL_{SET,RESTORE}_FLAGS  [Karel Zak]
   - fix "make -C" bug  [Karel Zak]
   - fix blkid detection in configure.ac  [Karel Zak]
   - fix blkid.h include for old e2fsprogs  [Karel Zak]
cal:
   - Highlight today even when month or year specified  [Rajeev V. Pillai]
   - uClibc has langinfo.h but not _NL_TIME_WEEK_1STDAY.  [Tom Prince]
chrt:
   - don't assume SCHED_BATCH and SCHED_IDLE exist  [Aurelien Jarno]
docs:
   - update AUTHORS file  [Karel Zak]
fdisk:
   - (and cfdisk) fix to be consistent about maximum heads  [Chris Webb]
libblkid:
   - fix reiserfs name  [Karel Zak]
   - update man page  [Karel Zak]
   - blkid_do_safeprobe() has to be tolerant to RAIDs  [Karel Zak]
   - cleanup debug messages and return codes in blkid_do_probe()  [Karel Zak]
   - fix "hangs forever with partition type mdraid"  [Karel Zak]
   - make libuuid optional  [Karel Zak]
losetup:
   - handle symlinks in /dev/loop/  [Mike Frysinger]
lscpu:
   - fix cpuid code on x86/PIC  [Mike Frysinger]
mount:
   - fix undefined reference to `security_get_initial_context'  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update vi.po (from translationproject.org)  [Clytie Siddall]
tests:
   - add mdraid libblkid test  [Karel Zak]
   - don't run some mount tests for non-root users  [Karel Zak]
   - fix reiserfs test  [Karel Zak]
   - fix script that creates lscpu dumps  [Karel Zak]
   - move lscpu /proc and /sys dumps to tarballs  [Karel Zak]
   - remove broken Xen dumps for lscpu  [Karel Zak]

-- 
 Karel Zak  <kzak@redhat.com>
