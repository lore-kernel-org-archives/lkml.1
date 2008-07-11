Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbYGKA5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbYGKA5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbYGKA5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:57:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42423 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbYGKA5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:57:36 -0400
Date: Thu, 10 Jul 2008 18:57:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Multiple MSI, take 3
Message-ID: <20080711005719.GO14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'd like to thank Michael Ellerman for his feedback.  This is a much
better patchset than it used to be.

Changes since the previous patchset:
 - Dumped the variable renaming as it made the patchset harder to read.
 - Moved the addition of the 'multiple' field from the first patch to the
   second.
 - Changed the calling convention of arch_teardown_msi_irqs back to
   upstream.
 - Fix the docbook for pci_enable_msi_block
 - Limit powerpc's MSI allocation to 1 in arch_msi_check_device, not
   arch_setup_msi_irqs
 - Rewrote AHCI interrupt claiming code to handle failures better and to
   claim fewer interrupts if possible.

Outstanding things I'd like reviewed:
 - The x86-64 patch has received no comments so far.
 - The AHCI patch needs to be re-reviewed.  Sorry, Jeff.  It's a bit
   more complex than I'd like, but I don't see a clearer way to write
   it, given the nasty behaviour that the AHCI spec permits.
 - I've just added the MSI-HOWTO patch to this set.  New reviewers are
   welcome.

Patchset available as a git tree from:

git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git multiple-msi
(multiple-msi-20080710 is this patch set in particular)

Patches will be sent in reply to this message.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
