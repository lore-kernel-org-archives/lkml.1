Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZCBPqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZCBPqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZCBPqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:46:35 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:28268 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbZCBPqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:46:34 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "smcameron@yahoo.com" <smcameron@yahoo.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
Date: Mon, 2 Mar 2009 15:46:24 +0000
Subject: RE: hpsa: SCSI driver for HP Smart Array controllers
Thread-Topic: hpsa: SCSI driver for HP Smart Array controllers
Thread-Index: AcmZUICAWO4qWTwjTAmRsMvL9FRyowB/YeYA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA6824048@GVW0547EXC.americas.hpqcorp.net>
References: <968150.85968.qm@web33001.mail.mud.yahoo.com>
In-Reply-To: <968150.85968.qm@web33001.mail.mud.yahoo.com>
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

crap 

> -----Original Message-----
> From: Stephen Cameron [mailto:smcameron@yahoo.com] 
> Sent: Friday, February 27, 2009 8:59 PM
> To: linux-kernel@vger.kernel.org
> Cc: scameron@beardog.cca.cpqcorp.net; Miller, Mike (OS Dev)
> Subject: Re: hpsa: SCSI driver for HP Smart Array controllers
> 
> 
> 
> I see we botched this in hpsa_pci_init() (one of the last 
> things we changed):
> 
> +       if (prod_index == ARRAY_SIZE(products)) {
> +               prod_index--;
> +               if (subsystem_vendor_id == !PCI_VENDOR_ID_HP ||
> +                               !allow_unknown_smartarray) {
> +                       printk(KERN_WARNING "hpsa: Sorry, I don't "
> +                               "know how to access the Smart "
> +                               "Array controller %08lx\n",
> 
> 
> That 2nd if should have been, 
> 
> if (subsystem_vendor_id != PCI_VENDOR_ID_HP ||
> 
> -- steve
> 
> 
>       
> 