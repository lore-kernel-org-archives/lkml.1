Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbXBECjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbXBECjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXBECjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:39:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:21814 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXBECju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:39:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=ssMVhx5pd9cuDdOiqONv62zUcDMjVsp+nvXrjPQfiU/0TfU4xQj6Lk8z9rt6+MdrEpPJO00FN7PjEP9NXu1cWuuNcYYxV+IFcH71sWZpc7iw9RUQD9XBngk9KHKDbf8mTWh20ARb4HIC4HvA5GmWM3KHYEUaQk6/WbdNgUwiVDg=
Date: Mon, 5 Feb 2007 04:39:35 +0200
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00] A series of patches to use ARRAY_SIZE macro under arch/
Message-ID: <20070205023935.GG18118@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

A series of patches to use ARRAY_SIZE macro under the `arch' subtree. 
Each architecture has its own mail/patch as a reply to this thread.
Those patches are not compile-tested as I don't have needed machines but
I tried hard to make sure that they are hopefully correct.
Patches can be applied cleanly on 2.6.20.

arm/kernel/ecard.c                   |    2 +-
arm26/kernel/ecard.c                 |    2 +-
avr32/kernel/setup.c                 |    4 ++--
cris/arch-v10/drivers/axisflashmap.c |    3 +--
cris/mm/tlb.c                        |    3 ++-
m68k/kernel/ptrace.c                 |    4 ++--
m68k/kernel/traps.c                  |    2 +-
m68knommu/kernel/ptrace.c            |    4 ++--
m68knommu/kernel/traps.c             |    2 +-
mips/arc/identify.c                  |    2 +-
mips/jmr3927/rbhma3100/setup.c       |    2 +-
mips/mips-boards/atlas/atlas_int.c   |    5 +++--
mips/mips-boards/malta/malta_int.c   |    5 +++--
mips/pci/fixup-vr4133.c              |    3 ++-
powerpc/lib/rheap.c                  |    3 ++-
powerpc/xmon/ppc-opc.c               |    7 +++----
powerpc/xmon/spu-opc.c               |    4 ++--
ppc/lib/rheap.c                      |    3 ++-
ppc/syslib/m8xx_setup.c              |    2 +-
ppc/xmon/ppc-opc.c                   |    7 +++----
v850/kernel/anna.c                   |    2 +-
v850/kernel/as85ep1.c                |    2 +-
v850/kernel/fpga85e2c.c              |    2 +-
v850/kernel/gbus_int.c               |    6 +++---
v850/kernel/ma.c                     |    2 +-
v850/kernel/me2.c                    |    2 +-
v850/kernel/rte_cb.c                 |    4 ++--
v850/kernel/rte_mb_a_pci.c           |    3 +--
v850/kernel/rte_me2_cb.c             |    3 +--
v850/kernel/teg.c                    |    2 +-
30 files changed, 49 insertions(+), 48 deletions(-)

Thanks,
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
