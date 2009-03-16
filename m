Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZCPPqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZCPPqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZCPPqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:46:25 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32439 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZCPPqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:46:25 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>, Kyle McMartin <kyle@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Mar 2009 15:45:46 +0000
Subject: RE: [PATCH trivial] cpqarray: enable bus mastering
Thread-Topic: [PATCH trivial] cpqarray: enable bus mastering
Thread-Index: AcmmFlkwZpIY89vBQ0KZKktvVzzIXQAN9vAg
Message-ID: <0F5B06BAB751E047AB5C87D1F77A7788672D8DDE4D@GVW0547EXC.americas.hpqcorp.net>
References: <20090315053842.GI3167@bombadil.infradead.org>
 <20090316090524.GM27476@kernel.dk>
In-Reply-To: <20090316090524.GM27476@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> Sent: Monday, March 16, 2009 4:05 AM
> To: Kyle McMartin
> Cc: Miller, Mike (OS Dev); linux-kernel@vger.kernel.org
> Subject: Re: [PATCH trivial] cpqarray: enable bus mastering
> 
> On Sun, Mar 15 2009, Kyle McMartin wrote:
> > From: Dave Jones <davej@redhat.com>
> > 
> > We've been carrying this patch for the last 3 years in Fedora, long 
> > past time we got it upstream...
> > 
> > Call pci_set_master to enable bus-mastering if the BIOS 
> hasn't done it 
> > already.
> > 
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> > Signed-off-by: Dave Jones <davej@redhat.com>
> > 
> > --- a/drivers/block/cpqarray.c	2006-10-06 
> 14:23:34.000000000 -0400
> > +++ b/drivers/block/cpqarray.c	2006-10-06 
> 14:25:16.000000000 -0400
> > @@ -614,6 +614,7 @@ static int cpqarray_pci_init(ctlr_info_t
> >  	int i;
> >  
> >  	c->pci_dev = pdev;
> > +	pci_set_master(pdev);
> >  	if (pci_enable_device(pdev)) {
> >  		printk(KERN_ERR "cpqarray: Unable to Enable PCI 
> device\n");
> >  		return -1;
> 
> Thanks Kyle, looks pretty innocent. Queued up for 2.6.30.
> 
> --
> Jens Axboe

Reviewed-by: Mike Miller <mike.miller@hp.com>
> 
> 