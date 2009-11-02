Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZKBXdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZKBXdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbZKBXdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:33:38 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:47799 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757260AbZKBXdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:33:37 -0500
Date: Mon, 2 Nov 2009 23:33:42 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: PULL: pull request for fixes-s3c-2632-rc5 [resend]
Message-ID: <20091102233342.GA27325@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resend of the following pull request:

The following changes since commit 1836d95928a0f41ada0cbb2a6c4e46b027db9491:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ericvh/v9fs

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git fixes-s3c-2632-rc5

Ben Dooks (8):
      ARM: S3C: Add info for supporting circular DMA buffers
      ARM: S3C2410: Fix link if CONFIG_S3C2410_IOTIMING is not set
      ARM: Merge fixes-s3c64xx
      ARM: Merge fixes-s3c64xx-dma
      ARM: S3C2440: mini2440: Fix missing CONFIG_S3C_DEV_USB_HOST
      ARM: S3C24XX: Fix warnings in arch/arm/plat-s3c24xx/gpio.c
      ARM: S3C2440: mini2440: Fix spare warnings
      ARM: S3C2410: Fix sparse warnings in arch/arm/mach-s3c2410/gpio.c

Harald Welte (1):
      ARM: S3C24XX: Introduce S3C2442B CPU

Julia Lawall (1):
      ARM: S3C24XX: arch/arm/plat-s3c24xx: Move dereference after NULL test

Kukjin Kim (1):
      ARM: S3C64XX: Fix S3C64XX_CLKDIV0_ARM_MASK value

Mark Brown (1):
      ARM: S3C64XX: Set rate of crystal mux

Ramax Lo (1):
      ARM: S3C24XX: Define a macro to avoid compilation error

Ryan Mallon (1):
      ARM: S3C: Fix adc function exports

 arch/arm/mach-s3c2410/gpio.c                       |    1 +
 arch/arm/mach-s3c2410/include/mach/dma.h           |    7 +++++++
 arch/arm/mach-s3c2440/Kconfig                      |    1 +
 arch/arm/mach-s3c2440/mach-mini2440.c              |    4 ++--
 arch/arm/mach-s3c6400/include/mach/dma.h           |    5 +++++
 arch/arm/plat-s3c24xx/adc.c                        |    2 +-
 arch/arm/plat-s3c24xx/cpu.c                        |   10 ++++++++++
 arch/arm/plat-s3c24xx/dma.c                        |    6 +++---
 arch/arm/plat-s3c24xx/gpio.c                       |    1 +
 arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h |    9 +++++++--
 arch/arm/plat-s3c24xx/include/plat/s3c2410.h       |    1 +
 arch/arm/plat-s3c64xx/include/plat/regs-clock.h    |    4 ++--
 arch/arm/plat-s3c64xx/s3c6400-clock.c              |    3 +++
 sound/soc/s3c24xx/s3c24xx-pcm.c                    |   17 +++++++++++++++--
 14 files changed, 59 insertions(+), 12 deletions(-)

