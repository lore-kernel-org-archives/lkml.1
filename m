Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044Ab0BZPTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:19:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016Ab0BZPTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:07 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86 platform drivers tree 
Date: Fri, 26 Feb 2010 10:18:33 -0500
Message-Id: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the x86 platform drivers are either entirely unrelated to ACPI, or
only barely so. So, with Len's blessing:

The following changes since commit baac35c4155a8aa826c70acee6553368ca5243a2:
  Xiaotian Feng (1):
        security: fix error return path in ima_inode_alloc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Erik Andren (1):
      dell-laptop: Add another Dell laptop to the DMI whitelist

Mario Limonciello (4):
      compal-laptop: Add support for known Compal made Dell laptops
      compal-laptop: Replace sysfs support with rfkill support
      dell-laptop: Block software state changes when rfkill hard blocked
      dell-laptop: Blacklist machines not supporting dell-laptop

Matthew Garrett (7):
      MAINTAINERS: update drivers/platform/x86 information
      dell-laptop: Update rfkill state on kill switch
      dell-laptop: Fix platform device unregistration
      dell-laptop: Fix small memory leak
      dell-laptop: Pay attention to which devices the hardware switch controls
      hp-wmi: Add support for tablet rotation key
      toshiba_acpi: Add full hotkey support

Stuart Hayes (1):
      dell-laptop: Use buffer with 32-bit physical address

Thadeu Lima de Souza Cascardo (1):
      classmate-laptop: use a single MODULE_DEVICE_TABLE to get correct aliases

 MAINTAINERS                             |   29 +++-
 drivers/platform/x86/Kconfig            |    1 +
 drivers/platform/x86/classmate-laptop.c |   31 +++--
 drivers/platform/x86/compal-laptop.c    |  247 +++++++++++++-----------------
 drivers/platform/x86/dell-laptop.c      |  256 ++++++++++++++++++++++++++-----
 drivers/platform/x86/hp-wmi.c           |    1 +
 drivers/platform/x86/toshiba_acpi.c     |  206 ++++++++++++++++++++++++-
 7 files changed, 575 insertions(+), 196 deletions(-)

