Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZDVP3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZDVP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZDVP3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:29:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47902 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751498AbZDVP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:29:37 -0400
Date: Wed, 22 Apr 2009 16:18:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniela Engert <dani@ngrt.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Message-ID: <20090422161856.1251f8a0@lxorguk.ukuu.org.uk>
In-Reply-To: <49EF337F.1030804@ngrt.de>
References: <20090422090929.GA14928@havoc.gtf.org>
	<49EEE225.3010700@garzik.org>
	<49EF0A92.1070400@panasas.com>
	<49EF337F.1030804@ngrt.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't forget, there are ATAPI devices (some Sony CD burners and old 
> phase-changers come into mind) which *do* have multiple LUNs sitting 
> beyond the PATA port. I don't know if libata supports such setups (my 
> old OS/2 driver does) but one shouldn't hijack LUNs to emulate targets.

It's a long time ago since I tested it but my 5 CD changer was correctly
supported by libata (or more accurately by sr...).

