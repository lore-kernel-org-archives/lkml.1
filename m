Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZIGJvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZIGJvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZIGJvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZIGJvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:51:48 -0400
Date: Mon, 7 Sep 2009 11:51:48 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.16.1
Message-ID: <20090907095148.GC7904@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The stable util-linux-ng 2.16.1 release is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/

(Note, 2.16.1 is stable maintenance release.)

Feedback and bug reports, as always, are welcomed.

	Karel


Util-linux-ng 2.16.1 Release Notes
==================================

Changes since v2.16
-------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/

build-sys:
   - don't distribute generated *.pc files  [Karel Zak]
cal:
   - fix (harmless) typo  [Peter Breitenlohner]
   - fix broken computation for Sep 1752  [Peter Breitenlohner]
dmesg:
   - add -r to help output  [Karel Zak]
docs:
   - update "The Perfect Patch" URL  [Karel Zak]
   - update AUTHORS file  [Karel Zak]
libblkid:
   - add *.ko.gz support to modules.dep parser  [Karel Zak]
   - allow linking with uClibc  [Daniel Mierswa]
   - fix FALSE definition  [Karel Zak]
   - fix buffer overflow in blkid_encode_string()  [Florian Zumbiehl]
   - fix cache->probe memory leak  [Karel Zak]
   - fix ext2 detection on systems with ext4 only  [Karel Zak]
mkswap:
   - fix memory leaks, cleanup check_blocks()  [Karel Zak]
   - unbreak -c ("check") option.  [Peter De Wachter]
mount:
   - add info about ext{3,4} barriers to mount.8  [Karel Zak]
   - clean up mount.8  [Karel Zak]
   - mention mtab for single mount point mount in mount.8  [Peter Volkov]
pg:
   - compiler warning with NLS disabled  [Peter Breitenlohner]
po:
   - fix grammar glitch in german translation  [Hendrik Lönngren]
   - merge changes  [Karel Zak]
   - update ja.po (from translationproject.org)  [Makoto Kato]
scriptreplay:
   - fix typo in error message  [Karel Zak]
tailf:
   - report inotify_add_watch() problems  [Karel Zak]


cal.1 cfdisk.8 chfn.1 chsh.1 ctrlaltdel.8 cytune.8 ddate.1 delpart.8 dmesg.1
elvtune.8 fdformat.8 fdisk.8 fsck.8 fsck.minix.8 fstab.5 getopt.1 hexdump.1
hwclock.8 initctl.8 ionice.1 ipcmk.1 ipcrm.1 ipcs.1 isosize.8 kill.1 last.1
ldattach.8: losetup.8: lscpu.1: mcookie.1: mesg.1: mkfs.8: mkfs.bfs.8:
mkfs.minix.8: mkswap.8: more.1: addpart.8: blockdev.8: mount.8: namei.1:
newgrp.1: partx.8: pg.1: pivot_root.8: rdev.8: readprofile.1: rename.1:
renice.1: reset.1: rtcwake.8: scriptreplay.1: setarch.8: setsid.1: setterm.1:
sfdisk.8: shutdown.8: simpleinit.8: swapon.8: switch_root.8: tunelp.8: ul.1:
umount.8: uuidd.8: uuidgen.1: vipw.8: whereis.1: write.1:

   - formatting  [Peter Breitenlohner]

-- 
 Karel Zak  <kzak@redhat.com>
