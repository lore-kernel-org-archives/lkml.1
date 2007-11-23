Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbXKWBvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbXKWBvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXKWBvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:51:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:5981 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXKWBvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:51:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=WT8tpu7VaMe1Sruek7SMYAlQ1FNWx4G6zL5goBgv+FrzYkAglHbK3y6Ur3UwrPMAMvOiHCqL7ozfr7P7xVzuGah2P3r0QGFvNMRkz0CxjTlZar6mvRLubW8bq8vPXISRaRu/saiO+qEnDnx+5aiuQkkppamMcPo6R19CrwFSjwI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Where is the interrupt going?
Date: Fri, 23 Nov 2007 02:58:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: niessner@jpl.nasa.gov, Kyle McMartin <kyle@mcmartin.ca>,
       linux-kernel@vger.kernel.org
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov> <20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov> <20071123012525.126010d5@the-village.bc.nu>
In-Reply-To: <20071123012525.126010d5@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711230258.56066.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 November 2007, Alan Cox wrote:
> On Thu, 22 Nov 2007 16:48:53 -0800
> niessner@jpl.nasa.gov wrote:
> 
> > 
> > I tried the hammer and the problem persists.
> 
> See my earlier email - your driver registers the irq with IRQF_DISABLED
> then never enables it.

As already explained by Kyle IRQF_DISABLED shouldn't matter here.

[ Nowadays IRQF_DISABLED only tells kernel/irq/handle.c::handle_IRQ_event()
  to not enable local interrupts before calling your IRQ handler.

  I've recently removed IRQF_DISABLED from IDE after noticing this. ]

Bart
