Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYGULoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYGULoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYGULoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:44:25 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:49431 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYGULoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:44:24 -0400
Date: Mon, 21 Jul 2008 13:43:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Please pull ACPI tree
Message-ID: <20080721114321.GA28786@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jul 2008 11:43:18.0158 (UTC) FILETIME=[F7F82AE0:01C8EB26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts some double commits and a trouble some FADT patch.

Also some last minute patches.

The following changes since commit 5b664cb235e97afbf34db9c4d77f08ebd725335e:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../mfasheh/ocfs2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-merge-2.6 release-2.6.27

Andi Kleen (4):
      Revert "Fix FADT parsing"
      Revert "dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled."
      Merge branch 'merge' into release-2.6.27
      Revert "ACPI: don't walk tables if ACPI was disabled"

Bjorn Helgaas (1):
      ACPI: stop complaints about interrupt link End Tags and blank IRQ descriptors

Zhao Yakui (2):
      ACPI: Ignore _BQC object when registering backlight device
      ACPI : Set FAN device to correct state in boot phase

 drivers/acpi/bay.c           |    3 --
 drivers/acpi/dock.c          |    3 --
 drivers/acpi/glue.c          |    3 --
 drivers/acpi/pci_link.c      |   31 +++++++++++++++++++----------
 drivers/acpi/tables/tbfadt.c |   17 +++++----------
 drivers/acpi/thermal.c       |   43 ++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/video.c         |   14 +++++++++++-
 7 files changed, 81 insertions(+), 33 deletions(-)
