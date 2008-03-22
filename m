Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYCVQnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYCVQnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYCVQnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:43:43 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:2553 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751697AbYCVQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:43:42 -0400
X-Trace: 701547335/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAFAHrT5EdRAVlC/2dsb2JhbACBW6Zi
Subject: Re: [PATCH 5/5] cdrom: make unregister_cdrom() return void
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
       Borislav Petkov <petkovbb@gmail.com>
In-Reply-To: <20080322031413.GE3665@APFDCB5C>
References: <20080322030948.GA3665@APFDCB5C>
	 <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C>
	 <20080322031248.GD3665@APFDCB5C>  <20080322031413.GE3665@APFDCB5C>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 16:43:23 +0000
Message-Id: <1206204203.6324.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-22 at 12:14 +0900, Akinobu Mita wrote:
> Now unregister_cdrom() always returns 0.
> Make it return void and update all callers that check the return value.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  Documentation/cdrom/cdrom-standard.tex |    2 +-
>  drivers/cdrom/cdrom.c                  |    3 +--
>  drivers/cdrom/gdrom.c                  |    4 +++-
>  drivers/cdrom/viocd.c                  |    5 +----
>  drivers/ide/ide-cd.c                   |    5 ++---
>  include/linux/cdrom.h                  |    2 +-
>  6 files changed, 9 insertions(+), 12 deletions(-)

I'm not sure if I need to ack this - but in case anybody is waiting :)

Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

