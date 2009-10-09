Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbZJIXQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbZJIXQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760555AbZJIXQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:16:34 -0400
Received: from kroah.org ([198.145.64.141]:36712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZJIXQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:16:33 -0400
Date: Fri, 9 Oct 2009 16:12:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/26] 2.6.31.4-stable review
Message-ID: <20091009231249.GA31084@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.31.4 release.
There are 26 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday October 11, 23:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.4-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

-----------

 .../networking/timestamping/timestamping.c         |    2 +-
 Makefile                                           |    2 +-
 arch/x86/ia32/ia32entry.S                          |   36 +++++++----
 arch/x86/include/asm/checksum_32.h                 |    3 +-
 arch/x86/kernel/acpi/cstate.c                      |    2 +-
 arch/x86/kernel/i8253.c                            |   27 ++++++--
 arch/x86/kvm/lapic.c                               |    2 +-
 arch/x86/kvm/svm.c                                 |    2 +
 arch/x86/kvm/vmx.c                                 |    2 +-
 arch/x86/kvm/x86.c                                 |    2 +
 drivers/acpi/osl.c                                 |    8 ++-
 drivers/ata/libata-eh.c                            |   50 +++++++++-----
 drivers/char/tty_ldisc.c                           |    7 +--
 drivers/ide/sis5513.c                              |   10 ++-
 drivers/net/iseries_veth.c                         |    2 +-
 fs/ecryptfs/main.c                                 |    7 ++-
 fs/namei.c                                         |    6 +-
 include/linux/ftrace.h                             |    2 +-
 kernel/exit.c                                      |    2 -
 kernel/fork.c                                      |   10 ++-
 kernel/futex.c                                     |    3 +-
 kernel/time/tick-sched.c                           |    9 ++-
 kernel/trace/ftrace.c                              |   23 ++-----
 mm/swap_state.c                                    |   70 +++++++++++++-------
 sound/pci/hda/patch_realtek.c                      |    1 +
 sound/pci/via82xx.c                                |   27 +++++---
 sound/soc/codecs/wm8350.c                          |    4 +-
 27 files changed, 203 insertions(+), 118 deletions(-)
