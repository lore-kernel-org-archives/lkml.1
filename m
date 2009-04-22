Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZDVQ1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZDVQ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZDVQ1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:27:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44262 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751345AbZDVQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:27:20 -0400
Date: Wed, 22 Apr 2009 17:27:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Daniela Engert <dani@ngrt.de>, Boaz Harrosh <bharrosh@panasas.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Message-ID: <20090422172710.0d9fcc6c@lxorguk.ukuu.org.uk>
In-Reply-To: <1240414622.3431.14.camel@mulgrave.int.hansenpartnership.com>
References: <20090422090929.GA14928@havoc.gtf.org>
	<49EEE225.3010700@garzik.org>
	<49EF0A92.1070400@panasas.com>
	<49EF337F.1030804@ngrt.de>
	<20090422161856.1251f8a0@lxorguk.ukuu.org.uk>
	<1240414622.3431.14.camel@mulgrave.int.hansenpartnership.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's a long time ago since I tested it but my 5 CD changer was correctly
> > supported by libata (or more accurately by sr...).
> 
> Well, sr supports the discovered CD/DVD; ch is the actual changer
> manager.  Usually ch attaches to one LUN and sr attaches to another.

I get 5 LUNS and the hardware looks after the rest - no changer manager
needed. Early versions of the gnome folks CD probing stuff did give it a
bit of a fit as the firmware clearly didn't cache all the state that the
cd mangler asked for.

