Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbZDVPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbZDVPhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZDVPhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:37:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57317 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbZDVPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:37:07 -0400
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniela Engert <dani@ngrt.de>, Boaz Harrosh <bharrosh@panasas.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <20090422161856.1251f8a0@lxorguk.ukuu.org.uk>
References: <20090422090929.GA14928@havoc.gtf.org>
	 <49EEE225.3010700@garzik.org> <49EF0A92.1070400@panasas.com>
	 <49EF337F.1030804@ngrt.de>  <20090422161856.1251f8a0@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 15:37:02 +0000
Message-Id: <1240414622.3431.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 16:18 +0100, Alan Cox wrote:
> > Don't forget, there are ATAPI devices (some Sony CD burners and old 
> > phase-changers come into mind) which *do* have multiple LUNs sitting 
> > beyond the PATA port. I don't know if libata supports such setups (my 
> > old OS/2 driver does) but one shouldn't hijack LUNs to emulate targets.
> 
> It's a long time ago since I tested it but my 5 CD changer was correctly
> supported by libata (or more accurately by sr...).

Well, sr supports the discovered CD/DVD; ch is the actual changer
manager.  Usually ch attaches to one LUN and sr attaches to another.

James


