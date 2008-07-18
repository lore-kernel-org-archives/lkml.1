Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYGRHkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYGRHkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYGRHjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:39:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:50088 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYGRHjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=KYFfNxr+uPtFsG0WUItgMuzXtFO2xN7jvso5XH6egMhrAC5qsGabB14fbHo9vxS17c
         dICdiiVLsKrJomNhPs6TKTQB6jmZt0UMbqZgFbtuCoGDCKYFuKG/RCQ1DWP/9/ESA7uo
         NrdE3fL84vA0qXb8v49UpbWLsddKK5HQ+Z7OY=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, gregkh@suse.de, lethal@linux-sh.org,
       i2c@lm-sensors.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 16:40:02 +0900
Message-Id: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
Subject: [PATCH 00/05] resource: type, size and IORESOURCE_CLK patches V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is V2 of the resource type, size and IORESOURCE_CLK patches.

[PATCH 01/05] resource: add resource_size()
[PATCH 02/05] resource: add resource_type() and IORESOURCE_TYPE_BITS
[PATCH 03/05] resource: add new IORESOURCE_CLK type V2
[PATCH 04/05] i2c-sh_mobile: IORESOURCE_CLK support
[PATCH 05/05] sh: add IORESOURCE_CLK to SuperH Mobile I2C platform data

Changes since V1
 - Just add a single bit for IORESOURCE_CLK
 - Dropped "[PATCH 03/04] resource: use new resource type changes" for now
 - Added IORESOURCE_CLK driver patch for i2c-sh_mobile
 - Added IORESOURCE_CLK platform data patch

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7343.c |   14 ++++++++++----
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |    7 +++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    7 +++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    7 +++++--
 drivers/base/platform.c                |   31 +++++++++++++++++--------------
 drivers/i2c/busses/i2c-sh_mobile.c     |    8 +++++++-
 include/linux/ioport.h                 |   28 +++++++++++++++++++---------
 kernel/resource.c                      |    2 +-
 8 files changed, 69 insertions(+), 35 deletions(-)
