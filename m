Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYAYJBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYAYJBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYAYJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:01:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:36012 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYAYJBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:01:22 -0500
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Jeff Garzik <jeff@garzik.org>
Message-Id: <F4B3DC7D-AC57-4C37-8708-5A3E73F5F97C@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
In-Reply-To: <4798AC8B.9090400@scram.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCHv3 6/7] [POWERPC] Rename commproc to cpm1 and cpm2_common.c to cpm2.c
Date: Fri, 25 Jan 2008 03:00:52 -0600
References: <4798AC8B.9090400@scram.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24, 2008, at 9:19 AM, Jochen Friedrich wrote:

> Rename commproc.[ch] to cpm1.[ch] to be more consistent with cpm2.  
> Also
> rename cpm2_common.c to cpm2.c as suggested by Scott Wood. Adjust the
> includes accordingly.
>
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
> arch/powerpc/platforms/8xx/ep88xc.c           |    1 +
> arch/powerpc/platforms/8xx/mpc86xads_setup.c  |    2 +-
> arch/powerpc/platforms/8xx/mpc885ads_setup.c  |    2 +-
> arch/powerpc/sysdev/Makefile                  |    4 ++--
> arch/powerpc/sysdev/{commproc.c => cpm1.c}    |    4 ++--
> arch/powerpc/sysdev/{cpm2_common.c => cpm2.c} |    3 +--
> arch/powerpc/sysdev/micropatch.c              |    2 +-
> arch/ppc/8260_io/enet.c                       |    2 +-
> arch/ppc/8xx_io/commproc.c                    |    2 +-
> arch/ppc/8xx_io/enet.c                        |    6 +++---
> arch/ppc/8xx_io/fec.c                         |    2 +-
> arch/ppc/8xx_io/micropatch.c                  |    2 +-
> arch/ppc/boot/simple/iic.c                    |    2 +-
> arch/ppc/boot/simple/m8xx_tty.c               |    2 +-
> arch/ppc/kernel/ppc_ksyms.c                   |    2 +-
> arch/ppc/platforms/mpc866ads_setup.c          |    2 +-
> arch/ppc/platforms/mpc885ads_setup.c          |    2 +-
> arch/ppc/syslib/mpc8xx_devices.c              |    2 +-
> arch/ppc/xmon/start_8xx.c                     |    2 +-

All of these files seem reasonable.

> drivers/net/fec.c                             |    8 --------
> drivers/net/fec.h                             |    2 +-

asm-m68knommu/commproc.h ?? these are only built on coldfire.

> drivers/net/fec_8xx/fec_8xx-netta.c           |    2 +-
> drivers/net/fec_8xx/fec_main.c                |    2 +-
> drivers/net/fec_8xx/fec_mii.c                 |    2 +-
> drivers/net/fs_enet/fs_enet.h                 |    2 +-
> drivers/net/fs_enet/mac-fec.c                 |    2 +-
> drivers/net/fs_enet/mac-scc.c                 |    2 +-

these seem ok.

> drivers/serial/68360serial.c                  |    2 +-

I think this is using asm-m68knommu/commproc.h

> drivers/serial/cpm_uart/cpm_uart_cpm1.h       |    2 +-
> include/asm-powerpc/{commproc.h => cpm1.h}    |    8 ++++----
> include/asm-ppc/{commproc.h => cpm1.h}        |    8 ++++----
> 31 files changed, 40 insertions(+), 48 deletions(-)
> rename arch/powerpc/sysdev/{commproc.c => cpm1.c} (99%)
> rename arch/powerpc/sysdev/{cpm2_common.c => cpm2.c} (99%)
> rename include/asm-powerpc/{commproc.h => cpm1.h} (99%)
> rename include/asm-ppc/{commproc.h => cpm1.h} (99%)

Also, CC jgarizk since we will be touching netdev drivers.  We've been  
pushing such updates via the powerpc tree's but its good that Jeff's  
aware.

- k

