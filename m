Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYGNPye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYGNPye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYGNPy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:54:26 -0400
Received: from outbound-mail-117.bluehost.com ([69.89.22.17]:34650 "HELO
	outbound-mail-117.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754184AbYGNPyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:54:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=C1h+BO+KDqb9r5mbU/EQFe4Eb3XUT4w3P8yHXrBUqiQEfFTBXMmxi4x+bffqNEV+hJZb+77oVsHeJ64lvaCpg2YoEnOc9Bo0DU97MTQc3u7YoIP0n9IMpTFxRuBFoECr;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: [osrc-patches] [PATCH] x86: Add PCI IDs for AMD Barcelona PCI devices
Date: Mon, 14 Jul 2008 08:54:11 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <20080627140905.EBD1C83D4@erda.amd.com> <20080711220837.21f7d24a@infradead.org> <20080714091506.GG7963@erda.amd.com>
In-Reply-To: <20080714091506.GG7963@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807140854.11864.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 14, 2008 2:15 am Robert Richter wrote:
> On 11.07.08 22:08:37, Arjan van de Ven wrote:
> > On Sat, 12 Jul 2008 06:56:15 +0200
> >
> > Ingo Molnar <mingo@elte.hu> wrote:
> > > * Robert Richter <robert.richter@amd.com> wrote:
> > > > Ingo, what about this patch. Could you apply it somewhere to the
> > > > tip tree? I will then fix all hardcoded device entries in the code.
> > >
> > > i suspect we could do it if the include/linux/pci_ids.h modification
> > > is fine with Jesse - it appears the maintenance policy right now is
> > > for everyone to add to include/linux/pci_ids.h on an as-needed basis:
> > >
> > > $ git-log-line linus..linux-next include/linux/pci_ids.h
> > >
> > > # 1126de5: Merge commit 'mmc/next'
> > > # bd3b052: Merge commit 'galak/powerpc-next'
> > > # edf0e24: powerpc/85xx: Add support for MPC8536DS
> > > # 34f80b0: bnx2x: Add support for BCM57711 HW
> > > # d3bca0e: sdhci: support JMicron secondary interface
> > > # 4ae127d: Merge branch 'master' of
> > > master.kernel.org:/pub/scm/linux/kernel/git/ # da65b53e4: Merge
> > > branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/ #
> > > da57e6983: tg3: Add 5785 ASIC revision
> > >
> > > Which would normally go fine and not create conflicts because the
> > > modifications are distributed randomly over that file.
> > >
> > > I'd suggest for you to send it together with the clean up patches, so
> > > that the context is clear.
>
> Ok. Will do it that way.
>
> > actually lately for most cases it seems the plan isn't to add to
> > pci_ids.h, but just do the PCI ID directly. It's not like a #define
> > adds any kind of information.
> > Vendor ID's otoh still happen (but obviously AMD is there since
> > forever.)
>
> Since the usage of these CPU device ids is spread over the whole
> kernel it makes sence to define it at a single point in
> pci_ids.h. This differs to device drivers that use only a single file
> with all the code, and thus, global defines are not necessary.

That's the rule I've been following too.  If a ID is just used in one place, 
like a driver, just keep the ID definition there (if you define it at all).  
But if it's used in multiple places around the tree, add a #define to 
pci_ids.h.

Thanks,
Jesse

