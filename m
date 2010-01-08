Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728Ab0AHUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0AHUId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975Ab0AHUIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:08:32 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:50009 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0AHUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:08:31 -0500
Date: Fri, 08 Jan 2010 15:08:03 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH 4/12] PCI PM: Make it possible to force using INTx for PCIe
 PME signaling
In-reply-to: <201001070000.41807.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.1001081502010.4012@localhost.localdomain>
References: <200912272057.10443.rjw@sisk.pl>
 <20100106135625.14b37f10@jbarnes-piketon>
 <20100106220214.GA25366@srcf.ucam.org> <201001070000.41807.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This scares me a little... seems like we're not restoring some state on
> > > resume that's needed for MSIs to work?  Looks fine though.
> > 
> > Yeah, that was my concern. We debugged this a little on IRC and didn't 
> > get anywhere, though, so probably need to find someone who knows more 
> > about MSIs...
> 
> I'd rather say someone who knows more about ICH7. :-)
> 
> MSIs work just fine after resume for the other devices in the same box,
> so I'd say it's a chipset issue.

Hmmm, do all the ICH7 boxes behave the same way?

Yesterday MSI announced a netbook running Suse/Moblin,
so there is hope for more technical work w/ MSI to support Linux...

It is a bit worrysome to go out of the gate to need a DMI blacklist
for relatively new hardware.

cheers,
Len Brown, Intel Open Source Technology Center


