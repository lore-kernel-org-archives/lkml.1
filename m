Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116Ab0ADCCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0ADCCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 21:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556Ab0ADCCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 21:02:37 -0500
Received: from [121.136.51.252] ([121.136.51.252]:47227 "EHLO ben-laptop"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751359Ab0ADCCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 21:02:36 -0500
X-Greylist: delayed 2104 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2010 21:02:36 EST
Date: Mon, 4 Jan 2010 10:27:13 +0900
From: Ben Dooks <ben-linux@fluff.org>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-samsung-soc@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: request pull: bjdooks' samsung fixes
Message-ID: <20100104012713.GA29175@ben-laptop.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for a couple of problems with the current ARM Samsung builds:

- touchscreen driver missing header files
- osiris and bast printing errors on non-existant custom fit nand devices

This is a slimed-down version of the previous pull request that seems to
have been ignored.

The following changes since commit 45d28b097280a78893ce25a5d0db41e6a2717853:
  Linus Torvalds (1):
        Merge branch 'reiserfs/kill-bkl' of git://git.kernel.org/.../frederic/random-tracing

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/samsung

Arnaud Patard (2):
      ARM: S3C24XX: touchscreen device definition
      ARM: S3C24XX: touchscreen device definition

Ben Dooks (5):
      ARM: mach-osiris: add NAND_SCAN_SILENT_NODEV to optional devices
      ARM: mach-bast: add NAND_SCAN_SILENT_NODEV to optional devices
      ARM: S3C: Fix NAND device registration by s3c_nand_set_platdata().
      ARM: Merge next-simtec
      ARM: Merge s3c24xx-updates2

 arch/arm/mach-s3c2410/include/mach/ts.h |   21 +++++++++++++++++++++
 arch/arm/mach-s3c2410/mach-bast.c       |    3 +++
 arch/arm/mach-s3c2410/mach-h1940.c      |    8 ++++++++
 arch/arm/mach-s3c2440/mach-osiris.c     |    2 ++
 arch/arm/plat-s3c/dev-nand.c            |    4 +++-
 arch/arm/plat-s3c/include/plat/devs.h   |    1 +
 arch/arm/plat-s3c24xx/devs.c            |   18 ++++++++++++++++++
 arch/arm/plat-s3c24xx/s3c244x.c         |    1 +
 8 files changed, 57 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-s3c2410/include/mach/ts.h

