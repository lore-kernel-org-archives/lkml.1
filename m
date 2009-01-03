Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbZACK0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbZACK0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZACK0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:26:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZACK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:26:11 -0500
Subject: [PATCH -tip 0/7] x86 rename mpc_config_X to mpc_X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:46:33 +0530
Message-Id: <1230977793.6138.17.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are first set of patches for cleanup related to mpspec as suggested by Ingo Molnar.
Once these are approved and applied then I will send next set of patches.

The following changes since commit 6ea161d36b1a3615f10a52bd5b19fac41653eea4:
  Ingo Molnar (1):
        Merge branch 'linus'

Jaswinder Singh Rajput (7):
      x86: rename mp_config_table to mpc_table
      x86: rename mpc_config_bus to mpc_bus
      x86: rename mpc_config_processor to mpc_cpu
      x86: rename mpc_config_ioapic to mpc_ioapic
      x86: rename mpc_config_intsrc to mpc_intsrc
      x86: rename mpc_config_lintsrc to mpc_lintsrc
      x86: rename mpc_config_oemtable to mpc_oemtable

 arch/x86/include/asm/es7000/mpparse.h            |    3 +-
 arch/x86/include/asm/genapic_32.h                |    8 +-
 arch/x86/include/asm/mach-default/mach_mpparse.h |    4 +-
 arch/x86/include/asm/mach-generic/mach_mpparse.h |    5 +-
 arch/x86/include/asm/mach-generic/mach_mpspec.h  |    4 +-
 arch/x86/include/asm/mpspec_def.h                |   14 ++--
 arch/x86/include/asm/numaq/mpparse.h             |    3 +-
 arch/x86/include/asm/setup.h                     |   14 ++--
 arch/x86/include/asm/summit/mpparse.h            |    2 +-
 arch/x86/kernel/mpparse.c                        |   98 ++++++++++------------
 arch/x86/kernel/numaq_32.c                       |   11 +--
 arch/x86/kernel/visws_quirks.c                   |    4 +-
 arch/x86/mach-generic/es7000.c                   |    8 +-
 arch/x86/mach-generic/numaq.c                    |    3 +-
 arch/x86/mach-generic/probe.c                    |    3 +-
 15 files changed, 84 insertions(+), 100 deletions(-)

Thank you,
	JSR

