Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXCQT4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXCQT4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 15:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXCQT4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 15:56:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXCQT4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 15:56:35 -0400
Date: Sat, 17 Mar 2007 15:56:25 -0400
From: Alan Cox <alan@redhat.com>
To: Paul Rolland <rol@as2917.net>
Cc: "'Alan Cox'" <alan@redhat.com>, "'Tejun Heo'" <htejun@gmail.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
Message-ID: <20070317195625.GB21441@devserv.devel.redhat.com>
References: <20070317185607.GC18870@devserv.devel.redhat.com> <00b701c768ca$a3919ca0$2101a8c0@donald>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00b701c768ca$a3919ca0$2101a8c0@donald>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  
> > > 
> > > Signed-off-by: Paul Rolland <rol@as2917.net>
> > 
> > NAK - but add the firmware to the match and you can have an Ack 8)
> 
> Second try, compiled _and_ boot tested, of course.
> 
> dmesg says :
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
> ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
> ata1.00: configured for UDMA/133
> 
> --- linux-2.6.21-rc4/drivers/ata/libata-core.c  2007-03-17 19:47:49.000000000
> +0100
> +++ linux-2.6.21-rc4-Maxtor/drivers/ata/libata-core.c   2007-03-17
> 20:24:01.000000000 +0100
> @@ -3359,6 +3359,8 @@
>          { "WDC WD740ADFD-00",   NULL,          ATA_HORKAGE_NONCQ },
>         /* http://thread.gmane.org/gmane.linux.ide/14907 */
>         { "FUJITSU MHT2060BH",  NULL,           ATA_HORKAGE_NONCQ },
> +       /* NCQ is broken */
> +       { "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ }, 
>  
>         /* Devices with NCQ limits */
> 
> Signed-off-by: Paul Rolland <rol@as2917.net>

Acked-by: Alan Cox <alan@redhat.com>

--
  'YKYHBRTFDriverSTLW: you catch yourself saying "enough horrors for today"
	and picking Lovecraft to relax...' -- Al Viro
