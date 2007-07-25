Return-Path: <linux-kernel-owner+w=401wt.eu-S934623AbXGYSCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623AbXGYSCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbXGYSCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:02:13 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:50564 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbXGYSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:02:11 -0400
Date: Wed, 25 Jul 2007 13:01:45 -0500
From: Scott Wood <scottwood@freescale.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver for CF	interface
Message-ID: <20070725180145.GA29689@ld0162-tx32.am.freescale.net>
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A78E3F.1030904@ru.mvista.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 09:54:07PM +0400, Sergei Shtylyov wrote:
>     Also, what mmio-ide in the compat properly means in the context of 
> ide_platform which is able to handle both port and memory mapped IDE.

I/O-space is only valid in the context of PCI, ISA, or similar buses, and
the bus-specific reg format indicates whether it's mmio-space or
io-space.

> I think we must get rid with this crap, and since this IDE register
> mapping is pretty much board specific, call it something like
> "mpc8349emitx-ide" instead.

What is board specific about a set of standard IDE registers at a given
address?  Do we need to make board-specific glue code for all of the
various ns16550-compatibles out there as well?

-Scott
