Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZDAGKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZDAGKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZDAGK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:10:27 -0400
Received: from smtp.nokia.com ([192.100.105.134]:28669 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZDAGK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:10:26 -0400
Subject: Re: [patch/rfc 2.6.29 2/2] MTD: support driver model updates
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <200903312257.37434.david-b@pacbell.net>
References: <200903260039.34013.david-b@pacbell.net>
	 <200903260042.50236.david-b@pacbell.net>
	 <1238564771.20906.26.camel@localhost.localdomain>
	 <200903312257.37434.david-b@pacbell.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Apr 2009 09:10:03 +0300
Message-Id: <1238566203.20906.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2009 06:10:05.0108 (UTC) FILETIME=[801B5740:01C9B290]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 22:57 -0700, David Brownell wrote:
> On Tuesday 31 March 2009, Artem Bityutskiy wrote:
> > > --- a/drivers/mtd/nand/mxc_nand.c
> > > +++ b/drivers/mtd/nand/mxc_nand.c
> > > @@ -866,6 +866,7 @@ static int __init mxcnd_probe(struct pla
> > >       mtd = &host->mtd;
> > >       mtd->priv = this;
> > >       mtd->owner = THIS_MODULE;
> > > +     mtd->dev.parent = &pdev->dev;
> > 
> > Could this be done for all NANDs in nand_base.c instead?
> 
> By adding the device as a parameter to nand_scan(),
> and presumably nand_scan_ident() ... which is a more
> invasive API change, and would require a "flag day"
> to convert all drivers.
> 
> My default assumption for API changes is to avoid
> flag days.  They can be done, yes, but I don't see
> a compelling reason to choose one here.

OK. MTD long needs sysfs, and I'm very happy with this
patches, even though they are not 100% complete. Good
start anyway.

Acked-by: Artem Bityutskiy <dedekind@infradead.org>

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

