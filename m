Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZLILiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZLILiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZLILiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:38:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbZLILiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:38:02 -0500
Date: Wed, 9 Dec 2009 12:38:06 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.17-rc2
Message-ID: <20091209113806.GA17935@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The second util-linux-ng 2.17 release candidate is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.17/

Feedback and bug reports, as always, are welcomed.

	Karel


Changes between v2.17-rc1 and v2.17-rc2
---------------------------------------

build-sys:
   - check for pkg-config before gtk-doc  [Karel Zak]
   - rewrite TLS detection  [Karel Zak]
flock:
   - fix hang when parent ignores SIGCHLD  [Mike Frysinger]
fsck:
   - document fsck behavior wrt nofail option and fstype 'auto'  [Ludwig Nussel]
   - honor nofail option in fsck  [Ludwig Nussel]
hexdump:
   - bug in hexdump when offset == file length  [Américo Wang]
libblkid:
   - fix UFS detection  [Karel Zak]
   - fix blkid_fstatat() code  [Karel Zak]
mount:
   - add --no-canonicalize option  [Karel Zak]
   - add a note about /dev/disk/by-* to mount.8  [Karel Zak]
   - add squashfs to mount.8  [Karel Zak]
   - add ubifs to the mount.8 man page  [Sebastian Andrzej Siewior]
   - better --move description  [Karel Zak]
   - move info about devices to the top of mount.8  [Karel Zak]
po:
   - update pl.po (from translationproject.org)  [Jakub Bogusz]
tailf:
   - fix printf format  [Mike Frysinger]
tests:
   - add UFS test image for libblkid  [Karel Zak]
   - add VIA RAID test image for libblkid  [Karel Zak]
   - remove vol_id from tests  [Karel Zak]


Release Notes:
  ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.17/v2.17-ReleaseNotes

Detailed ChangeLog:
  ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.17/v2.17-rc2-ChangeLog
  

-- 
 Karel Zak  <kzak@redhat.com>
