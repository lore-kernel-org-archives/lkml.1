Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZG2BK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZG2BK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZG2BK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:10:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59197 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZG2BK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:10:28 -0400
Message-ID: <4A6FA17F.20507@pobox.com>
Date: Tue, 28 Jul 2009 21:10:23 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
Subject: Re: [PATCH] libata: remove superfluous NULL pointer checks
References: <200907261605.14619.bzolnier@gmail.com>
In-Reply-To: <200907261605.14619.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] libata: remove superfluous NULL pointer checks
> 
> host->ports[] always contain pointers to valid port structures since
> a "dummy port" structure is used in case if there is no physical port.
> 
> This patch takes care of two entries from Dan's list:
> 
> drivers/ata/sata_sil.c +535 sil_interrupt(13) warning: variable derefenced before check 'ap'
> drivers/ata/sata_mv.c +2517 mv_unexpected_intr(6) warning: variable derefenced before check 'ap'
> 
> and of another needless NULL pointer check in pata_octeon_cf.c.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Cc: corbet@lwn.net
> Cc: eteo@redhat.com
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_octeon_cf.c |    3 ++-
>  drivers/ata/sata_mv.c        |    2 +-
>  drivers/ata/sata_sil.c       |    2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)

applied to #upstream-fixes


