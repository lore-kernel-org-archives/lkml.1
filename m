Return-Path: <linux-kernel-owner+w=401wt.eu-S1765262AbXHIXrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765262AbXHIXrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbXHIXrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:47:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:45900 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbXHIXq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Lwy45BF/GyqML8wJwCfRiZ1WClhciUal2xfz8Onj2bBO5jv/UNz4OjOlYwv0veEXOq8+97krIvkSGfARyiCwlpxLVci8ak7xy5yzudAcslTMinFFqrFTgrkWkxsO9IQw+T/0vsixKYilSQAQdGK1gJTNZ0oLkfUNKM5PZRBT7eI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for AEC6880[R]
Date: Fri, 10 Aug 2007 01:45:38 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200708092319.34828.bzolnier@gmail.com> <20070809235455.3117d5dc@the-village.bc.nu>
In-Reply-To: <20070809235455.3117d5dc@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708100145.38739.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2007, Alan Cox wrote:
> On Thu, 9 Aug 2007 23:19:34 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > 
> > Maximum supported UDMA mode for AEC6280[R] is UDMA5 (not UDMA4)
> > and for AEC6880[R] it is UDMA6 (not UDMA5):
> > 
> > * Fix the problem by adding missing struct ata_port_info to artop_init_one().
> > 
> > * Use the right naming (s/626/628/).
> > 
> > * Bump driver version.
> > 
> > Fixes IDE->libata regression, problem was never present in IDE aec62xx driver.
> 
> Have you tested this ??

-ENODEV so no and testing is welcomed.

However I went over both drivers to make sure that this change is safe
and correct.

BTW presence of the above bugs would strongly indicate that pata_artop has
never been tested (properly) with AEC6x80[R], otherwise these bugs should
have been noticed and fixed much earlier.

Thanks,
Bart
