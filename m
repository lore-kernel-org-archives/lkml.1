Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZK3VJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZK3VJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZK3VJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:09:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbZK3VJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:09:23 -0500
Date: Mon, 30 Nov 2009 22:09:28 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.16.2 (stable)
Message-ID: <20091130210928.GD16217@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The stable util-linux-ng 2.16.2 release is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/

(Note, 2.16.2 is stable maintenance release.)

Feedback and bug reports, as always, are welcomed.

	Karel


Util-linux-ng 2.16.2 Release Notes
==================================

Changes since v2.16.1
---------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/

docs:
   - update AUTHORS file  [Karel Zak]
fdformat:
   - fix memory leak in verify_disk()  [Cristian Rodríguez]
fsck.minix:
   - fix broken zone checking  [Karel Zak]
hwclock:
   - do not access hardware clock when using --systz  [Scott James Remnant]
   - set kernel timezone with --systz --utc  [Scott James Remnant]
lib:
   - fix file descriptor leak in is_mounted()  [Theodore Ts'o]
libblkid:
   - add missing packed attributes, add new UFS magic strings  [Karel Zak]
   - fix FAT super block definition  [Lawrence Rust]
   - fix blkid_probe_set_utf8label() call for Joliet  [Karel Zak]
   - fix the default cache file path  [Karel Zak]
   - fix typo (swsupend -> swsuspend)  [Karel Zak]
   - prefer ISO9660 PVD Label to Joliet Label  [Karel Zak]
   - trim tailing whitespace from unicode LABELs  [Karel Zak]
libuuid:
   - remove .UE macro from libuuid man pages.  [Milan Broz]
mkswap:
   - restore device argument in mkswap.8 synopsis  [Peter Breitenlohner]
mount:
   - document changed semantics of tmpfs size option in mount.8  [kevin.granade@gmail.com]
   - more explicitly explain 'strictatime' in mount.8  [Karel Zak]
   - update list of pseudo filesystems  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update id.po (from translationproject.org)  [Arif E. Nugroho]
   - update pl.po (from translationproject.org)  [Jakub Bogusz]
   - update vi.po (from translationproject.org)  [Clytie Siddall]
sfdisk:
   - dump has to be $LANG insensitive  [Karel Zak]
swapon:
   - handle <=linux-2.6.19 bug in /proc/swaps  [Mike Frysinger]
switch_root:
   - remove TIOCSCTTY and setsid()  [Karel Zak]
tailf:
   - fix printf format  [Mike Frysinger]
-- 
 Karel Zak  <kzak@redhat.com>
