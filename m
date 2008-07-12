Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbYGLFIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbYGLFIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYGLFIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:08:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:53904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYGLFIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:08:41 -0400
Date: Fri, 11 Jul 2008 22:08:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [osrc-patches] [PATCH] x86: Add PCI IDs for AMD Barcelona PCI
 devices
Message-ID: <20080711220837.21f7d24a@infradead.org>
In-Reply-To: <20080712045615.GA11092@elte.hu>
References: <20080627140905.EBD1C83D4@erda.amd.com>
	<20080711124659.GC7963@erda.amd.com>
	<20080712045615.GA11092@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 06:56:15 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > Ingo, what about this patch. Could you apply it somewhere to the
> > tip tree? I will then fix all hardcoded device entries in the code.
> 
> i suspect we could do it if the include/linux/pci_ids.h modification
> is fine with Jesse - it appears the maintenance policy right now is
> for everyone to add to include/linux/pci_ids.h on an as-needed basis:
> 
> $ git-log-line linus..linux-next include/linux/pci_ids.h
> 
> # 1126de5: Merge commit 'mmc/next'
> # bd3b052: Merge commit 'galak/powerpc-next'
> # edf0e24: powerpc/85xx: Add support for MPC8536DS
> # 34f80b0: bnx2x: Add support for BCM57711 HW
> # d3bca0e: sdhci: support JMicron secondary interface
> # 4ae127d: Merge branch 'master' of
> master.kernel.org:/pub/scm/linux/kernel/git/ # da65b53e4: Merge
> branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/ #
> da57e6983: tg3: Add 5785 ASIC revision
> 
> Which would normally go fine and not create conflicts because the 
> modifications are distributed randomly over that file.
> 
> I'd suggest for you to send it together with the clean up patches, so 
> that the context is clear.

actually lately for most cases it seems the plan isn't to add to
pci_ids.h, but just do the PCI ID directly. It's not like a #define
adds any kind of information.
Vendor ID's otoh still happen (but obviously AMD is there since
forever.)



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
