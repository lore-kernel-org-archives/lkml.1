Return-Path: <linux-kernel-owner+w=401wt.eu-S935457AbXHGXMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935457AbXHGXMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbXHGXMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:12:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbXHGXL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:11:59 -0400
Date: Wed, 8 Aug 2007 01:11:56 +0200
From: Karel Zak <kzak@redhat.com>
To: List util-linux-ng <util-linux-ng@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng 2.13-rc3
Message-ID: <20070807231156.GB3185@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The third util-linux-ng 2.13 release candidate is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/

Feedback and bug reports, as always, are welcomed.

    Karel


v2.13-rc3 changelog:
~~~~~~~~~~~~~~~~~~~

agetty:
   - 8 bit characters on the Linux console lead to input corruption  [Moritz Muehlenhoff]
   - fix short malloc in initstring handling  [LaMont Jones]
blockdev:
   - fix "blockdev --getsz" for large devices  [Karel Zak]
   - use LU and LLU for BLKGETSIZE and BLKGETSIZE64  [Karel Zak]
build-sys:
   - add ${AC,AP,AM,AH}_OPTS to autogen.sh  [Karel Zak]
   - add warning when libuuid is not found  [Karel Zak]
   - fix directories in EXTRA_DIST  [Karel Zak]
   - missing header when NLS is disabled  [Gabriel Barazer]
   - release++  [Karel Zak]
   - remove asm/page.h test  [Karel Zak]
cytune:
   - remove linux/tty.h inclusion  [Karel Zak]
disk-utils:
   - let mkfs tools open with O_EXCL  [Matthias Koenig]
docs:
   - add rdev(8) between deprecated utils  [Karel Zak]
fdisk:
   - add support for udev persistent device names  [Matthias Koenig]
   - cleanup partname.c  [Karel Zak]
ionice:
   - cleanup usage for idle class  [Matthias Koenig]
logger:
   - use snprintf instead of sprintf in logger.c  [LaMont Jones]
look:
   - man page clarification  [Pádraig Brady]
mkfs:
   - remove nonsense from man page  [Karel Zak]
mkswap:
   - default to V1 in any case  [Matthias Koenig]
   - fix signedness problems and remove obsolete code  [Karel Zak]
mount:
   - fix -f -o remount  [Karel Zak]
   - fix incorrect behavior when more than one fs type is specified  [Attila Áfra]
   - mention hfsplus in mount manpage  [LaMont Jones]
   - should set proper permissions on locktime  [Flávio Leitner]
   - update xfs mount options  [Matthias Koenig]
po:
   - update po/ stuff  [Karel Zak]
rdev:
   - should be delivered on amd64 as well as i386.  [LaMont Jones]
readprofile:
   - fix on ppc64  [Matthias Koenig]
script:
   - fix race conditions  [Karel Zak]
   - improve quiet mode  [Karel Zak]
swapoff:
   - correctly handle UUID= and LABEL= identifiers  [LaMont Jones]
swapon:
   - cleanup fsprobe_*() usage  [Karel Zak]
tests:
   - add license notices, change from gplv2-only to gplv2-or-later  [Karel Zak]
   - add script(1) race condition test  [Karel Zak]
   - add warning "For development purpose only."  [Karel Zak]
   - use $AWK based on configure results  [Karel Zak]
   - use relative paths when sourcing files  [Mike Frysinger]

- manpage typos  [LaMont Jones]
- remove hardcoded package name from some utils  [Karel Zak]



-- 
 Karel Zak  <kzak@redhat.com>
