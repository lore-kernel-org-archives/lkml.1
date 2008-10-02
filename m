Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYJBS7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYJBS7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYJBS7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:59:10 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:44469 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbYJBS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:59:08 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI probing debug message uniformization
Date: Thu, 2 Oct 2008 12:59:05 -0600
User-Agent: KMail/1.9.9
Cc: "Vincent Legoll" <vincent.legoll@gmail.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com> <200810021146.28704.jbarnes@virtuousgeek.org>
In-Reply-To: <200810021146.28704.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021259.05864.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008 12:46:28 pm Jesse Barnes wrote:
> On Monday, September 29, 2008 2:03 pm Vincent Legoll wrote:
> > Hello,
> >
> > Here is a patch to uniformize PCI probing debug messages at
> > boot with dev_printk() intead of manual printk()
> >
> > for example, it goes from the mixed-style:
> >
> > PCI: 0000:00:1b.0 reg 10 64bit mmio: [f4280000, f4283fff]
> > pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> >
> > to uniform:
> >
> > pci 0000:00:1b.0: reg 10 64bit mmio: [f4280000, f4283fff]
> > pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> >
> > If people prefer the UPPERCASE "PCI:" prefix from dev_printk(),
> > that would be matter for another patch...
> >
> > I'm currently running the kernel with that patch applied, and
> > diffed bootlog, everything looks OK
> >
> > Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
> 
> Bjorn, how does this jive with the various other debug harmonization patches 
> you've been putting together & reviewing?

I think it's great.  The only nit I would change is to use
"[%#llx-%#llx]" as we do in pci_request_region().

Bjorn
