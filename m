Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZBDBTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZBDBTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBDBTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:19:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42183 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZBDBTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:19:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/7] PCI PM: Fixes and refinements
Date: Wed, 4 Feb 2009 01:54:35 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902040154.36018.rjw@sisk.pl>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches contains some fixes and refinements of the
PCI PM framework.

[1/7] fixes the problem that some driverless devices don't like to be power
managed and break things if we attempt to do it.

[2/7] and [3/7] fix the problem with devices in PCI_UNKNOWN that are
mishandled by the new code.

[4/7] fixes regression related to PCIe port suspend-resume.

[5/7] fixes the bug that bridges (and PCIe ports) are disabled during suspend,
althouth they shouldn't be.

[6/7] makes pci_restore_standard_config() read the current power state of the
device from the device itself after attempting to change it.

[7/7] makes the PCI PM core handle devices more carefully (details in the
changelog).

Please disregard any previous versions of these patches I sent to you.

Thanks,
Rafael

