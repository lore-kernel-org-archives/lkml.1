Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYGXTOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYGXTOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYGXTOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:14:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:52322 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYGXTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=A5nVXd5ZepN9LocIlIdWXzi8DvBrIaO6AfIfYyWAVZCW2PGCWPQ4ShwxOkvLXX8qXM
         Ps2ToklPxTJ1u+Q+H5DhBUH0EXOnTlRx/aXD0hCKYIZ7P3KHY1kF2NteB72uw8C2/Or5
         n4UelmDl2s/1p49sxxpsEDZj2SX2czethFsP8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: add missing ATA_ID_* defines (take 2)
Date: Thu, 24 Jul 2008 20:53:37 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807222249.32242.bzolnier@gmail.com> <48879938.8010803@pobox.com>
In-Reply-To: <48879938.8010803@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242053.38082.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008, Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Add missing ATA_ID_* defines and update {ata,atapi}_*()
> > inlines accordingly.  The currently unused defines are
> > needed for the forthcoming drivers/ide/ changes.
> > 
> > v2:
> > Add ATA_ID_SPG.
> > 
> > Cc: Jeff Garzik <jgarzik@pobox.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > v2 was needed because one define got lost :/
> > 
> >  include/linux/ata.h |  122 ++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 76 insertions(+), 46 deletions(-)
> 
> ACK, and I'll send this one upstream myself.  It shouldn't conflict with 
> the patches just ACK'd.

OK.
