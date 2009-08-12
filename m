Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbZHLK0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbZHLK0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbZHLK0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:26:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52545 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbZHLK0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:26:15 -0400
Message-ID: <4A8298B6.4060608@garzik.org>
Date: Wed, 12 Aug 2009 06:25:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Krystian Juskowiak <jusko@tlen.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bbpetkov@yahoo.de>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_atiixp: fix slave device support
References: <200908061740.15902.bzolnier@gmail.com> <200908061747.05944.bzolnier@gmail.com>
In-Reply-To: <200908061747.05944.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Thursday 06 August 2009 17:40:15 Bartlomiej Zolnierkiewicz wrote:
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Subject: [PATCH] pata_atiixp: fix slave device support
> 
> Argh, I pushed the "Send" button too quick..
> 
> Below version with the correct patch description
> (I doubt that this fix will help with bug #13921)..
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH v2] pata_atiixp: fix second channel support
> 
> PIO and MWDMA timings are never programmed for the second channel
> because timing registers are treated as 16-bit long ones.
> 
> The bug is an attixp -> pata_atiixp regression and goes back to:
> 
> 	commit 669a5db411d85a14f86cd92bc16bf7ab5b8aa235
> 	Author: Jeff Garzik <jeff@garzik.org>
> 	Date:   Tue Aug 29 18:12:40 2006 -0400
> 
> 	    [libata] Add a bunch of PATA drivers.
> 
> Cc: Krystian Juskowiak <jusko@tlen.pl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Borislav Petkov <bbpetkov@yahoo.de>
> Cc: Robert Hancock <hancockrwd@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> After this patch pata_atiixp still have two bugs (+ few superfluous oddities)
> not present in atiixp (although not as severe as this one)..
> 
>  drivers/ata/pata_atiixp.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

applied


