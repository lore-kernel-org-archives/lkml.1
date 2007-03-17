Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbXCQS4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbXCQS4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 14:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXCQS4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 14:56:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbXCQS4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 14:56:16 -0400
Date: Sat, 17 Mar 2007 14:56:07 -0400
From: Alan Cox <alan@redhat.com>
To: Paul Rolland <rol@as2917.net>
Cc: "'Tejun Heo'" <htejun@gmail.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
Message-ID: <20070317185607.GC18870@devserv.devel.redhat.com>
References: <00a701c768bd$f8abe130$2101a8c0@donald> <00ae01c768c4$a673e3c0$2101a8c0@donald>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00ae01c768c4$a673e3c0$2101a8c0@donald>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 07:47:01PM +0100, Paul Rolland wrote:
> Hello,
> 
> Here is a patch to avoid these pesky messages for the Maxtor disk :
> 

Please match the firmware version as well for the Maxtor drives

> --- linux-2.6.21-rc4/drivers/ata/libata-core.c  2007-03-17 19:29:45.000000000
> +0100
> +++ linux-2.6.21-rc4-Maxtor/drivers/ata/libata-core.c   2007-03-17
> 19:37:28.000000000 +0100
> @@ -3359,6 +3359,8 @@
>          { "WDC WD740ADFD-00",   NULL,          ATA_HORKAGE_NONCQ },
>         /* http://thread.gmane.org/gmane.linux.ide/14907 */
>         { "FUJITSU MHT2060BH",  NULL,           ATA_HORKAGE_NONCQ },
> +       /* NCQ is broken */
> +       { "Maxtor 6L250S0",     NULL,           ATA_HORKAGE_NONCQ }, 
>  
>         /* Devices with NCQ limits */
>  
> 
> Signed-off-by: Paul Rolland <rol@as2917.net>

NAK - but add the firmware to the match and you can have an Ack 8)
