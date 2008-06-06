Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYFFS0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYFFS0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762853AbYFFS0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:26:17 -0400
Received: from outbound-mail-38.bluehost.com ([69.89.20.192]:59933 "HELO
	outbound-mail-38.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762803AbYFFS0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:26:14 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [git pull] PCI fixes
Date: Fri, 6 Jun 2008 11:26:10 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061126.11037.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull a few more fixes for 2.6.26:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

There's nothing big or critical here, just a couple of things that would be
nice to see in 2.6.26: a fix for OLPC and a new quirk for VIA bridges.

Thanks,
Jesse

Andres Salomon (1):
      PCI/x86: fix up PCI stuff so that PCI_GOANY supports OLPC

Bertram Felgenhauer (1):
      x86/PCI: add workaround for bug in ASUS A7V600 BIOS (rev 1005)

 arch/x86/Kconfig    |   11 +++++------
 arch/x86/pci/init.c |    3 ++-
 arch/x86/pci/irq.c  |    7 +++++++
 arch/x86/pci/olpc.c |    5 +++--
 arch/x86/pci/pci.h  |    2 +-
 5 files changed, 18 insertions(+), 10 deletions(-)
