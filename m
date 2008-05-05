Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbYEETSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbYEETSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYEETS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:18:29 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:54188 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751725AbYEETS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:18:28 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [git pull] PCI updates
Date: Mon, 5 May 2008 12:18:26 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051218.26255.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the PCI fixes:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

There are a few bug fixes in there and a patch moved over from the x86
tree, which has a couple of cleanups and a small enhancement for the
ISA alignment code (it's also now controllable through a kernel boot
parameter).  I can push that over into the linux-next tree though if you're
not comfortable with it.

Thanks,
Jesse

Sam Ravnborg (1):
      x86: fix section mismatch in pci_scan_bus

Yinghai Lu (3):
      x86/pci: remove flag in pci_cfg_space_size_ext
      x86/pci: add pci=skip_isa_align command lines.
      x86 PCI: call dmi_check_pciprobe()

 Documentation/kernel-parameters.txt |    2 +
 arch/x86/pci/acpi.c                 |   41 -------------------------
 arch/x86/pci/common.c               |   58 +++++++++++++++++++++++++++++++++---
 arch/x86/pci/fixup.c                |    2 -
 arch/x86/pci/init.c                 |    4 ++
 arch/x86/pci/pci.h                  |    3 +
 drivers/pci/probe.c                 |   33 ++++++++++----------
 include/linux/pci.h                 |    5 +--
 8 files changed, 84 insertions(+), 64 deletions(-)
