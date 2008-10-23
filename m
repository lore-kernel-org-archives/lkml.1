Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYJWGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYJWGe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYJWGes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:34:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35762 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYJWGer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:34:47 -0400
Date: Thu, 23 Oct 2008 08:33:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH 2/2] libata: switch to using block layer tagging support
Message-ID: <20081023063349.GR22217@kernel.dk>
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-3-git-send-email-jens.axboe@oracle.com> <48FFC96E.5060604@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FFC96E.5060604@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22 2008, Jeff Garzik wrote:
> Jens Axboe wrote:
> >libata currently has a pretty dumb ATA_MAX_QUEUE loop for finding
> >a free tag to use. Instead of fixing that up, convert libata to
> >using block layer tagging - gets rid of code in libata, and is also
> >much faster.
> >
> >Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >---
> > drivers/ata/libata-core.c |   66 
> > ++++----------------------------------------
> > drivers/ata/libata-scsi.c |   10 +++++-
> > drivers/ata/libata.h      |   19 +++++++++++-
> > include/linux/libata.h    |    1 -
> > 4 files changed, 31 insertions(+), 65 deletions(-)
> 
> Just to be sure, I take it this patch series is for 2.6.29?

Sure yes, it was written and tested just the other day :-)

> Seems nice to have, but since it wasn't ready for the merge window 
> opening...

Indeed, but it can certainly wait for 2.6.29.

-- 
Jens Axboe

