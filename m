Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbXLRP4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbXLRP4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbXLRPz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:55:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:49012 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbXLRPz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:55:56 -0500
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <054B7122-6815-4483-96FE-7B4098198FA1@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <20071218023915.8530.67500.stgit@terra.home>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 1/7] Copy mpc-i2c to preserve support for ARCH=ppc and allow changes on ARCH=powerpc
Date: Tue, 18 Dec 2007 09:53:28 -0600
References: <20071218023913.8530.46661.stgit@terra.home> <20071218023915.8530.67500.stgit@terra.home>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 17, 2007, at 8:39 PM, Jon Smirl wrote:

> Temporarily copy the mpc-i2c driver to continue support for the ppc  
> architecture until it is removed in mid-2008. This file should be  
> deleted as part of ppc's final removal.
>
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
>
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
>
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
> ---
>
> arch/ppc/configs/TQM8540_defconfig     |    2
> arch/ppc/configs/TQM8541_defconfig     |    2
> arch/ppc/configs/TQM8555_defconfig     |    2
> arch/ppc/configs/TQM8560_defconfig     |    2
> arch/ppc/configs/mpc834x_sys_defconfig |    2
> arch/ppc/configs/mpc8540_ads_defconfig |    2
> arch/ppc/configs/mpc8548_cds_defconfig |    2
> arch/ppc/configs/mpc8555_cds_defconfig |    2
> arch/ppc/configs/mpc8560_ads_defconfig |    2
> drivers/i2c/busses/Kconfig             |   16 +
> drivers/i2c/busses/Makefile            |    1
> drivers/i2c/busses/i2c-mpc-ppc.c       |  418 +++++++++++++++++++++++ 
> +++++++++
> 12 files changed, 443 insertions(+), 10 deletions(-)
> create mode 100644 drivers/i2c/busses/i2c-mpc-ppc.c

Nak.

Just ifdef the probe functionality in i2c-mpc.c based on  
CONFIG_PPC_MERGE.  Your patch set shows the reason you should do  
this.  You provide fixes to the error path handling, but only for i2c- 
mpc.c and not i2c-mpc-ppc.c.

- k
