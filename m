Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYGTGsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYGTGsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYGTGsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:48:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50112 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYGTGsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:48:41 -0400
Date: Sun, 20 Jul 2008 08:48:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jack Howarth <howarth@bromo.msbb.uc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] x86,pci: detect end_bus_number according to acpi/e820
	reserved
Message-ID: <20080720064809.GA25439@elte.hu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080718214825.GA8132@bromo.msbb.uc.edu> <86802c440807181527u1e373b2drc72456b33a4bcd76@mail.gmail.com> <200807181542.42670.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807181542.42670.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Friday, July 18, 2008 3:27 pm Yinghai Lu wrote:
> > On Fri, Jul 18, 2008 at 2:48 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> 
> wrote:
> > > YH,
> > >  I'll test the new patch shortly. When I do, I'll put back in
> > > your debug patches to try to get a complete log with pci=verbose
> > > and initcall_debug with PCIEASPM disabled.
> >
> > tip tree has the two debug patches.
> >
> > > Hopefully the probing
> > > is done in the same general fashion with and without PCIEASPM so
> > > we can deduce what exactly is being probed when my MacBook Pro
> > > freezes during boot with PCIEASPM enabled. I consider the fact
> > > that booting 2.6.26 always freezes the kernel when PCIEASPM
> > > is enabled to be the more serious bug (since once Fedora ships
> > > 2.6.26 kernels I'll be stuck always building my own).
> >
> > another laptop : Acer ... suffer this problem too with ASPM...
> 
> Yeah, looks like we'll have to be more conservative about enabling 
> ASPM.  Maybe a whitelist approach would be better...

all my testsystems boot fine with it. Maybe a blacklist? :)

	Ingo
