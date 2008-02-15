Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYBOPwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYBOPwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYBOPwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:52:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:36997 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751764AbYBOPwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:52:32 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/cmrYYtdTcSobHkIkIyWNRaPNrnOSDAwpZhUDRsU
	WS4sYEgOzZ0qXK
Date: Fri, 15 Feb 2008 16:52:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Tim Ellis <tim@ngndg.com>, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
In-Reply-To: <1202850129.7410.22.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
 <1202850129.7410.22.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Benjamin Herrenschmidt wrote:

> On Tue, 2008-02-12 at 15:58 +0000, Tim Ellis wrote:
> 
> > This change causes attached drives to no longer be detected and  
> > function on the PowerPC Buffalo Linkstation machines:
> > 
> > <7>pata_sil680 0000:00:0c.0: version 0.4.8
> > <6>sil680: 133MHz clock.
> > <6>scsi0 : pata_sil680
> > <6>scsi1 : pata_sil680
> > <6>ata1: PATA max UDMA/133 irq 18
> > <6>ata2: PATA max UDMA/133 irq 18
> > 
> > If I roll back this driver to before this change with 2.6.24.2 it works:
> 
> Hrm... and we need those patches for blades that have a sil680
> controller with no working PIO on the PCI host...
> 
> That's strange though. Somebody with knowledge of that HW (or specs) who
> can spot something ? Could it be an issue with timing ?
> 
> I don't have HW access to this machine. If somebody could send one to me
> I could do more investigation.

Ben, would an ssh access to such a machine and to a terminal server 
suffice?

Thanks
Guennadi
---
Guennadi Liakhovetski
