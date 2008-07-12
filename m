Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYGLE4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYGLE4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 00:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYGLE4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 00:56:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYGLE4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 00:56:31 -0400
Date: Sat, 12 Jul 2008 06:56:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [osrc-patches] [PATCH] x86: Add PCI IDs for AMD Barcelona PCI
	devices
Message-ID: <20080712045615.GA11092@elte.hu>
References: <20080627140905.EBD1C83D4@erda.amd.com> <20080711124659.GC7963@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711124659.GC7963@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo, what about this patch. Could you apply it somewhere to the tip 
> tree? I will then fix all hardcoded device entries in the code.

i suspect we could do it if the include/linux/pci_ids.h modification is 
fine with Jesse - it appears the maintenance policy right now is for 
everyone to add to include/linux/pci_ids.h on an as-needed basis:

$ git-log-line linus..linux-next include/linux/pci_ids.h

# 1126de5: Merge commit 'mmc/next'
# bd3b052: Merge commit 'galak/powerpc-next'
# edf0e24: powerpc/85xx: Add support for MPC8536DS
# 34f80b0: bnx2x: Add support for BCM57711 HW
# d3bca0e: sdhci: support JMicron secondary interface
# 4ae127d: Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/
# da65b53e4: Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/
# da57e6983: tg3: Add 5785 ASIC revision

Which would normally go fine and not create conflicts because the 
modifications are distributed randomly over that file.

I'd suggest for you to send it together with the clean up patches, so 
that the context is clear.

	Ingo

> On 27.06.08 16:04:28, Robert Richter wrote:
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  include/linux/pci_ids.h |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index eafc9d6..4a2557c 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -497,6 +497,11 @@
> >  #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
> >  #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
> >  #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
> > +#define PCI_DEVICE_ID_AMD_10H_NB_HT	0x1200
> > +#define PCI_DEVICE_ID_AMD_10H_NB_MAP	0x1201
> > +#define PCI_DEVICE_ID_AMD_10H_NB_DRAM	0x1202
> > +#define PCI_DEVICE_ID_AMD_10H_NB_MISC	0x1203
> > +#define PCI_DEVICE_ID_AMD_10H_NB_LINK	0x1204
> >  #define PCI_DEVICE_ID_AMD_LANCE		0x2000
> >  #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
> >  #define PCI_DEVICE_ID_AMD_SCSI		0x2020
> > -- 
> > 1.5.5.4
> > 
> > _______________________________________________
> > osrc-patches mailing list
> > osrc-patches@elbe.amd.com
> > https://ddcwww.amd.com/mailman/listinfo/osrc-patches
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
