Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbXEYQMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbXEYQMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXEYQMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:12:01 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41041 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbXEYQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:12:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070525052032.GB9386@suse.de>
	<m1myztaq5s.fsf@ebiederm.dsl.xmission.com> <adawsyw52tl.fsf@cisco.com>
	<adasl9k52q8.fsf@cisco.com>
Date: Fri, 25 May 2007 10:10:13 -0600
In-Reply-To: <adasl9k52q8.fsf@cisco.com> (Roland Dreier's message of "Fri, 25
	May 2007 08:42:39 -0700")
Message-ID: <m18xbcc2ai.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

>  >  > - In spec hardware does not require MSI to generate interrupts
>  >  >   Which leaves enabling MSI optional.
>  > 
>  > Actually at least the Qlogic/Pathscale PCI Express ipath adapters
>  > cannot generate INTx interrupts -- they definitely do require MSI to
>  > operate.
>
> Oh yeah... when I first found out about this, I rechecked the PCI
> Express spec and found that in fact legacy INTx interrupts are
> optional.  So the ipath adapters that require MSI do conform to the
> spec.

Hmm...

I find in section 6.1:
> In addition to PCI INTx compatible interrupt emulation, PCI Express
> requires support of MSI or MSI-X or both. 
Which suggests that INTx support is required.

I do not find any wording that suggest the opposite.
I do see it stated that it is intended to EOL support for INTx at
some point.

Where did you see it mentioned that INTx was optional?

I do see it clearly stating that MSI is the preferred mechanism from
pci express.

Eric
