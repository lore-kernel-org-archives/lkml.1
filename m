Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbXHOIRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbXHOIRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbXHOIRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:17:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41731 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbXHOIRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:17:32 -0400
Message-ID: <46C2B699.3080408@garzik.org>
Date: Wed, 15 Aug 2007 04:17:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for AEC6880[R]
References: <200708092319.34828.bzolnier@gmail.com>
In-Reply-To: <200708092319.34828.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Maximum supported UDMA mode for AEC6280[R] is UDMA5 (not UDMA4)
> and for AEC6880[R] it is UDMA6 (not UDMA5):
> 
> * Fix the problem by adding missing struct ata_port_info to artop_init_one().
> 
> * Use the right naming (s/626/628/).
> 
> * Bump driver version.
> 
> Fixes IDE->libata regression, problem was never present in IDE aec62xx driver.
> 
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_artop.c |   19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)

applied to #upstream-fixes


