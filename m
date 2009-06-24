Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZFXBth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZFXBth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZFXBsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:48:46 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:36042 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZFXBsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=eQuN0a1cfm+sANnhXG+tRxkw0AFPHcHzG+PZ7OoSVzwrbeAC+yq90KnwFACE0FKIrh
         ngegsGI/icS0Q/Jj+PGTCREGLEW+SQ7VgpWlvFclOwy4BiwzZsYAalMfBV7iE4Ct7irz
         aMXz/fpQsIw4eac8gYe4AR8SzXOstU45zuyEY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 6/6] ide: improve handling of Power Management requests
Date: Wed, 24 Jun 2009 03:36:33 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906232335.57161.bzolnier@gmail.com> <20090623.162402.125952364.davem@davemloft.net>
In-Reply-To: <20090623.162402.125952364.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906240336.33702.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 01:24:02 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 23 Jun 2009 23:35:56 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: improve handling of Power Management requests
> > 
> > Make hwif->rq point to PM request during PM sequence and do not allow
> > any other types of requests to slip in (the old comment was never correct
> > as there should be no such requests generated during PM sequence).
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > This was tested in the past (with an additional testing from Borislav)
> > however there were block layer changes in the meantime so you may want
> > to give it some more testing time just to be sure.
> 
> In looking at this change, it occurs to me that this queue blocking
> facility could also be used to solve the user SET_XFER race.
> 
> Couldn't it?

Probably.  This is software, almost everything is possible.. ;)
