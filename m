Return-Path: <linux-kernel-owner+w=401wt.eu-S1764630AbXKOMgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764630AbXKOMgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXKOMgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:36:38 -0500
Received: from ozlabs.org ([203.10.76.45]:35669 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbXKOMgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:36:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] ata_sg_setup_one vs ata_sg_setup?
Date: Thu, 15 Nov 2007 23:36:34 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <200711141540.58658.rusty@rustcorp.com.au> <473BC620.9020204@gmail.com>
In-Reply-To: <473BC620.9020204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152336.34708.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 15:08:00 Tejun Heo wrote:
> Rusty Russell wrote:
> > Hi Jeff,
> >
> >     Was looking through libata, and it seems to me that ata_sg_setup is a
> > superset of ata_sg_setup_one.  Am I missing something?  Seems like it
> > could be simplified.
> >
> > My machine never seems to do an ata_sg_setup_one, so this patch isn't
> > really tested...
>
> I have about the same patch queued here which also kills
> ata_sg_init_one() completely and replaces
> ATA_QCFLAG_SG/ATA_QCFLAG_SINGLE with ATA_QCFLAG_DMAMAP (now a single
> flag).  I'll compare your version and mine and see if mine is missing
> something.
>
> Thanks.

Great, thanks for the feedback.  I'd guess mine is more likely missing 
something than yours though...

Cheers,
Rusty.
