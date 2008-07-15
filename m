Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYGOXI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYGOXI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYGOXIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:08:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYGOXIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:08:15 -0400
Date: Wed, 16 Jul 2008 01:07:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: akataria@vmware.com, "ak@linux.intel.com" <ak@linux.intel.com>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
Subject: Re: acpi based pci gap calculation  - v3
Message-ID: <20080715230755.GC31249@elte.hu>
References: <1216148382.6135.21.camel@alok-dev1> <200807151328.00739.jbarnes@virtuousgeek.org> <1216155256.6135.25.camel@alok-dev1> <200807151553.41403.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807151553.41403.jbarnes@virtuousgeek.org>
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

> On Tuesday, July 15, 2008 1:54 pm Alok Kataria wrote:
> > I have tested it with couple of different BIOS settings and it seems to
> > work as it should.
> >
> > > Most of the PCI bugs we
> > > have at the moment are related to PCI resource allocation failures.  My
> > > hope is that finding more space will fix most of them.  Assuming this
> > > patch doesn't have any dependencies, I can put it in my linux-next
> > > branch.
> >
> > No dependencies, I had added a function e820_search_gap which is 
> > used by this patch. This function is already in the mainline tree. 
> > Thanks for applying.
> 
> Ok, I stuffed it in my linux-next branch.  I'll let it sit there for a 
> day or so though, just to shake out any build problems etc. in 
> linux-next before asking Linus to pull the whole lot.

thanks. The general x86 infrastructure bits this patch depends on are 
upstream already.

	Ingo
