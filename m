Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXFVQmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXFVQmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXFVQmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:42:44 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:34568 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXFVQmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:42:43 -0400
X-IronPort-AV: i="4.16,452,1175486400"; 
   d="scan'208"; a="43065329:sNHT30857897"
Subject: [GIT PULL] please pull blackfin-2.6.git
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Sat, 23 Jun 2007 00:41:50 +0800
Message-Id: <1182530510.6408.3.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 22 Jun 2007 16:42:42.0155 (UTC) FILETIME=[5A2D53B0:01C7B4EC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, 

Please pull from 

  master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git/ master

Some Blackfin bug fixing and update.

Mike Frysinger (3):
      Blackfin arch: add missing braces around array bfin serial init
      Blackfin arch: move cond_syscall() behind __KERNEL__ like all other architectures
      Blackfin arch: add proper const volatile to addr argument to the read functions

Robin Getz (3):
      Blackfin arch: update ANOMALY handling
      Blackfin arch: update printk to use KERN_EMERG and reformat crash output
      Blackfin arch: match kernel startup messaage with new linker script

Sonic Zhang (1):
      Blackfin arch: Add definition of dma_mapping_error

 arch/blackfin/kernel/setup.c                       |    8 +-
 arch/blackfin/kernel/traps.c                       |  141 ++++++++++++--------
 arch/blackfin/lib/memcmp.S                         |    5 +
 arch/blackfin/lib/memcpy.S                         |   13 ++-
 arch/blackfin/lib/memmove.S                        |   17 ++-
 arch/blackfin/mach-common/cache.S                  |   20 ++--
 arch/blackfin/mach-common/interrupt.S              |    2 +-
 include/asm-blackfin/blackfin.h                    |   33 +++++-
 include/asm-blackfin/dma-mapping.h                 |    2 +
 include/asm-blackfin/io.h                          |    6 +-
 include/asm-blackfin/mach-bf533/anomaly.h          |   84 +++++++++++-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h  |    2 +
 include/asm-blackfin/mach-bf537/anomaly.h          |   21 +++-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h  |    2 +
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |   27 ++++
 include/asm-blackfin/unistd.h                      |    3 +-
 16 files changed, 299 insertions(+), 87 deletions(-)
