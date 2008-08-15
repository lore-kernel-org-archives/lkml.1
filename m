Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYHOCH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYHOCH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYHOCHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:07:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45541 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYHOCHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:07:16 -0400
Date: Fri, 15 Aug 2008 04:07:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Please pull ACPI fixes
Message-ID: <20080815020713.GA8111@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest ACPI fixes from 

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6.git release-2.6.27

Now finally with a octopus merge, hopefully I'm a cool kid too now.

-Andi

Andi Kleen (1):
      Merge branches 'acpica-release-fixes', 'ec-fix', 'dock', 'irq-bounds', 'thermal-fix', 'wmi' and 'acpi-cleanups' into release-2.6.27

Bjorn Helgaas (1):
      ACPI: bounds check IRQ to prevent memory corruption

Bob Moore (2):
      ACPICA: Fix memory leak when deleting thermal/processor objects
      ACPICA: Additional error checking for pathname utilities

Carlos Corbacho (2):
      ACPI: WMI: Set instance for query block calls
      acer-wmi: Fix wireless and bluetooth on early AMW0 v2 laptops

Holger Macht (1):
      ACPI: Properly clear flags on false-positives and send uevent on sudden unplug

Lin Ming (1):
      ACPICA: Fix possible memory leak in Unload() operator

Milan Broz (1):
      ACPI: Fix thermal shutdowns

Pavel Machek (1):
      acpi: trivial cleanups

Zhao Yakui (2):
      ACPI : Add the EC dmi table to fix the incorrect ECDT table
      ACPI: Avoid bogus EC timeout when EC is in Polling mode

 drivers/acpi/dock.c               |   11 ++++++++---
 drivers/acpi/ec.c                 |   36 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/executer/exconfig.c  |    3 +++
 drivers/acpi/namespace/nsnames.c  |   34 ++++++++++++++++++++++------------
 drivers/acpi/pci_link.c           |   12 +++++++-----
 drivers/acpi/processor_core.c     |    2 +-
 drivers/acpi/processor_idle.c     |    1 -
 drivers/acpi/processor_perflib.c  |    2 +-
 drivers/acpi/resources/rscalc.c   |    3 +++
 drivers/acpi/utilities/utalloc.c  |    8 +++++---
 drivers/acpi/utilities/utdelete.c |   13 +++++++++++--
 drivers/acpi/utilities/utobject.c |   13 +++++++++----
 drivers/acpi/wmi.c                |    2 +-
 drivers/misc/acer-wmi.c           |   19 +++++++++++++++++++
 include/acpi/acnamesp.h           |    2 +-
 15 files changed, 127 insertions(+), 34 deletions(-)

