Return-Path: <linux-kernel-owner+w=401wt.eu-S1767288AbXDEUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767288AbXDEUPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767287AbXDEUPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:15:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51745 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767285AbXDEUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:15:36 -0400
Date: Thu, 5 Apr 2007 21:18:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Subject: Re: [PATCH] HPA support: Revised patch
Message-ID: <20070405211804.1f64e515@the-village.bc.nu>
In-Reply-To: <20070405192421.GB5131@lug-owl.de>
References: <20070405141352.12fddb6e@the-village.bc.nu>
	<20070405192421.GB5131@lug-owl.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int ata_ignore_hpa = 0;
> > +module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> > +MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=off 1=on)");
> > +
> >  static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
> >  module_param(ata_probe_timeout, int, 0444);
> >  MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
> 
> For ignore_hpa, it would be nice to not go through inverse logic and
> fix the help text a bit (0=honor HPA, 1=ignore HPA).

Umm.. how about  "preserve_hpa" ?

Alan
