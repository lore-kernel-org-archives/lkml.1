Return-Path: <linux-kernel-owner+w=401wt.eu-S965598AbXFFWpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598AbXFFWpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXFFWpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:45:25 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:18141 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965230AbXFFWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:45:22 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46673964.1000004@am.sony.com>
Date: Wed, 06 Jun 2007 15:47:00 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Big problems applying patch-2.6.21.3-rt9
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 22:45:16.0876 (UTC) FILETIME=[5A6450C0:01C7A88C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I saw lots of problems trying to apply the latest rt-preempt patch.
Maybe some bits got included by mistake in the patch?

Here's what I saw:
$ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.3.tar.bz2
$ wget http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.3-rt9
$ tar -xjf linux-2.6.21.3.tar.bz2
$ cd linux-2.6.21.3
$ patch -p1 -f <../patch-2.6.21.3-rt9
... lots of errors, (many "already applied" errors if you don't use '-f')...
$ find . -name "*.rej"
./arch/arm/kernel/traps.c.rej
./arch/arm/mach-iop13xx/pci.c.rej
./arch/arm/plat-iop/time.c.rej
./arch/i386/kernel/cpu/cpufreq/powernow-k7.c.rej
./arch/i386/kernel/cpu/cpufreq/powernow-k8.c.rej
./arch/i386/kernel/cpu/cpufreq/powernow-k8.h.rej
./arch/sparc64/kernel/prom.c.rej
./arch/x86_64/kernel/vsyscall.c.rej
./crypto/api.c.rej
./drivers/ata/libata-sff.c.rej
./drivers/ata/sata_via.c.rej
./drivers/base/core.c.rej
./drivers/char/ipmi/ipmi_si_intf.c.rej
./drivers/crypto/geode-aes.c.rej
./drivers/crypto/geode-aes.h.rej
./drivers/md/raid1.c.rej
./drivers/message/fusion/mptspi.c.rej
./drivers/net/Kconfig.rej
./drivers/net/bnx2.c.rej
./drivers/net/sis900.c.rej
./drivers/net/skge.c.rej
./drivers/net/sky2.c.rej
./drivers/net/smc911x.c.rej
./drivers/net/tg3.c.rej
./drivers/pci/quirks.c.rej
./drivers/usb/atm/cxacru.c.rej
./drivers/usb/input/hiddev.c.rej
./fs/fat/dir.c.rej
./fs/jfs/jfs_logmgr.c.rej
./fs/nfsd/export.c.rej
./fs/reiserfs/xattr.c.rej
./fs/udf/namei.c.rej
./include/asm-arm/arch-iop13xx/iop13xx.h.rej
./include/asm-sparc64/openprom.h.rej
./include/linux/netfilter/nf_conntrack_proto_gre.h.rej
./include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h.rej
./include/linux/clocksource.h.rej
./include/linux/netdevice.h.rej
./kernel/time/clocksource.c.rej
./kernel/time/tick-common.c.rej
./kernel/time/tick-internal.h.rej
./kernel/time/tick-sched.c.rej
./lib/zlib_inflate/inflate.c.rej
./mm/hugetlb.c.rej
./mm/oom_kill.c.rej
./mm/slob.c.rej
./net/ipv4/netfilter/ip_conntrack_core.c.rej
./net/ipv4/netfilter/ip_nat_proto_gre.c.rej
./net/ipv4/netfilter/nf_nat_proto_gre.c.rej
./net/ipv4/tcp.c.rej
./net/ipv6/addrconf.c.rej
./net/ipv6/exthdrs.c.rej
./net/ipv6/ip6_input.c.rej
./net/ipv6/ip6_output.c.rej
./net/ipv6/proc.c.rej
./net/ipv6/xfrm6_tunnel.c.rej
./net/netfilter/nf_conntrack_core.c.rej
./net/sched/sch_prio.c.rej
./net/sctp/socket.c.rej
./net/sunrpc/auth_gss/svcauth_gss.c.rej
./scripts/basic/fixdep.c.rej
./sound/pci/hda/patch_sigmatel.c.rej
./Makefile.rej

I can send you the full output from patch if you want.
Please advise.
  -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

