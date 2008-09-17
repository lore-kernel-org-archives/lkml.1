Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYIQFkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYIQFkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYIQFjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:39:49 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:19433 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYIQFjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:39:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Martin Doucha <next_ghost@quick.cz>
Subject: Re: ACPI PnP on Intel MU440EX
Date: Tue, 16 Sep 2008 23:39:39 -0600
User-Agent: KMail/1.9.9
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       matthieu castet <castet.matthieu@free.fr>
References: <48BA9B2C.7060007@quick.cz> <200809091034.46729.bjorn.helgaas@hp.com> <48CD65D0.9090202@quick.cz>
In-Reply-To: <48CD65D0.9090202@quick.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809162339.40330.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 01:28:16 pm Martin Doucha wrote:
> Bjorn Helgaas wrote:
> > Thanks very much for the report.  This sounds like it could be a
> > PNPACPI issue, which I am very interested in fixing.
> >
> > Can you please turn on CONFIG_PNP_DEBUG in your .config and collect
> > the complete dmesg log with and without "pnpacpi=off"?
> >
> > I do have an "lspnp" that works with PNPACPI here:
> >   http://kernel.org/pub/linux/kernel/people/helgaas/pnputils-0.1.tar.bz2
> > but it's not widely used.  The debug information from the config
> > option above is usually more useful.
> >
> > Bjorn
> 
> I'm sorry it took me so long, here's the output of lspnp -vvv from both 
> PNPBIOS and ACPI PnP (same kernel, the only difference is pnpacpi=off 
> boot argument). I can't find any mention of my parallel port in ACPI PnP 
> output but it's the last listed device (00:15 PNP0400) in PNPBIOS output.

I don't see the parallel port either.  Can you please open a
bugzilla for this and attach the complete dmesg log and the
ACPI table dump using the instructions here:

  http://kernel.org/pub/linux/kernel/people/helgaas/debug

You can put it in the Drivers/PNP category and add me to the cc:
list.

I assume the parallel port has *never* worked with ACPI enabled,
right?

Bjorn
