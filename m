Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYGXTPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYGXTPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYGXTOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:14:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:52450 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYGXTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=RuNgWWF6ZU1vOdKqRcFYj0Ilh4TOD+XRxZ2lDa8LyQhfQIQKEAC0f8Bb1RU8Lid5id
         kMlf6Q+TJNR42zryP00TD2bOZ22zvGR1XNQ4WIgPzfLgddDAj7hAat80LO5WAa5Zno2A
         hvHBfaCev18tI/Y6f5F4QV4Yqj/8p9OWABcXc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH {1,3}/7] ata: add missing ATA_CMD_* defines
Date: Thu, 24 Jul 2008 21:07:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
References: <200807232042.45733.bzolnier@gmail.com> <200807232040.18264.bzolnier@gmail.com> <20080723235237.GA11354@puku.stupidest.org>
In-Reply-To: <20080723235237.GA11354@puku.stupidest.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807242107.36740.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Chris Wedgwood wrote:
> On Wed, Jul 23, 2008 at 08:40:18PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> > Add missing ATA_CMD_* defines to <linux/ata.h>.  Also add
> > ATA_EXABYTE_ENABLE_NEST, SETFEATURES_AAM_* and ATA_SMART_*
> > defines while at it.
> >
> > Partially based on earlier work by Chris Wedgwood.
> 
> [...]
> 
> 
> On Wed, Jul 23, 2008 at 08:42:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > * Use ATA_CMD_* defines instead of WIN_* ones.
> >
> > While at it:
> >
> > * EXABYTE_ENABLE_NEXT -> ATA_EXABYTE_ENABLE_NEST
> >
> > * SETFEATURES_{EN,DIS}_WCACHE -> SETFEATURES_WC_{ON,OFF}
> >
> > * SETFEATURES_{EN,DIS}_AAM -> SETFEATURES_AAM_{ON,OFF}
> >
> > * SMART_* -> ATA_SMART_*
> >
> > * Remove stale comment from ide-proc.c.
> >
> > Partially based on earlier work by Chris Wedgwood.
> 
> ACK/signoff from me (in so far as it's relevant, my original patches
> are so old I'm sure Bart probably had to so it almost all again).

Thanks, added your ACK to #1/#3 and Jeff's to #1/#2.
