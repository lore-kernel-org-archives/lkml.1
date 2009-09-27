Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZI0Hyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZI0Hyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 03:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZI0Hye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 03:54:34 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:11921 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbZI0Hyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 03:54:33 -0400
Date: Sun, 27 Sep 2009 03:54:34 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Crane Cai <crane.cai@amd.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: acpi tree build failure
In-reply-to: <20090927012716.GB10173@crane-desktop>
Message-id: <alpine.LFD.2.00.0909270353100.16783@localhost.localdomain>
References: <20090926121528.dfba135e.sfr@canb.auug.org.au>
 <1253934703.16789.21.camel@dc7800.home> <20090927012716.GB10173@crane-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > drivers/i2c/busses/i2c-scmi.c: In function 'acpi_smbus_cmi_add':
> > > drivers/i2c/busses/i2c-scmi.c:374: error: implicit declaration of function 'acpi_device_uid'
> > > drivers/i2c/busses/i2c-scmi.c:374: warning: format '%s' expects type 'char *', but argument 5 has type 'int'
> > > 
> > > Caused by commit 6622d8cee73a26bce958484065c8f0e704911a62 ("ACPI: remove
> > > acpi_device_uid() and related stuff") interacting with commit
> > > dc9854212e0d7318d7133697906d98b78f3088b6 ("i2c: Add driver for SMBus
> > > Control Method Interface") recently added to Linus' tree.
> > > 
> > > I have used the version of the acpi tree from next-20090925 for today.
> > 
> > I think we should use the following patch to remove the usage of
> > acpi_device_uid().  Crane, do you agree, or is there some special
> > reason you need it here?

> I agree.

Thanks Crane, upstream now includes Bjorn's patch.

-Len Brown, Intel Open Source Technology Center
