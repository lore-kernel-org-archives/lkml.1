Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZBAVjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZBAVjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 16:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZBAVjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 16:39:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZBAVjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:39:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/3] PCI PM: More refinements of suspend-resume framework
Date: Sun, 1 Feb 2009 22:29:26 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012229.27517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After the recent discussion with Linus, I have the following three fixes of the
PCI PM framework.

The first patch fixes the bug that bridges (and PCIe ports) are disabled
during suspend, althouth they shouldn't.

The second one makes the PCI PM core handle devices more carefully (details
in the changelog). [Note to Linus: devices are still put into low power states
with interrupts on after this patch.  Moving that to the late suspend phase
will be the next step.]

The last patch makes the warning in pci_legacy_suspend() more useful.

Thanks,
Rafael

