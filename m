Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZG2BKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZG2BKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZG2BKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:10:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59203 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZG2BKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:10:41 -0400
Message-ID: <4A6FA18D.1070808@pobox.com>
Date: Tue, 28 Jul 2009 21:10:37 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
Subject: Re: [PATCH] libata: add missing NULL pointer check to ata_eh_reset()
References: <200907261621.01893.bzolnier@gmail.com>
In-Reply-To: <200907261621.01893.bzolnier@gmail.com>
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
> Subject: [PATCH] libata: add missing NULL pointer check to ata_eh_reset()
> 
>>From Dan's list:
> 
> drivers/ata/libata-eh.c +2403 ata_eh_reset(80) warning: variable derefenced before check 'slave'
> 
> Please note that this is _not_ a real bug at the moment since ata_eh_context
> structure is embedded into ata_list structure and the code alwas checks for
> 'slave' before accessing 'sehc'.
> 
> Anyway lets add missing check and always have a valid 'sehc' pointer (which
> makes code easier to understand and prevents introducing some possible bugs
> in the future).
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Cc: corbet@lwn.net
> Cc: eteo@redhat.com
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/libata-eh.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to #upstream-fixes


