Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZDAKNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZDAKNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZDAKNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:13:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52747 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZDAKNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:13:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 13/13] DRBD: final
Date: Wed, 1 Apr 2009 12:13:01 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jens.axboe@oracle.com,
       nab@risingtidestorage.com, andi@firstfloor.org,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1238431643-19433-7-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-16-git-send-email-philipp.reisner@linbit.com> <20090330190530.GA4028@uranus.ravnborg.org>
In-Reply-To: <20090330190530.GA4028@uranus.ravnborg.org>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904011213.02121.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 21:05:30 Sam Ravnborg wrote:
> > +#
> > +config BLK_DEV_DRBD
> > +	tristate "DRBD Distributed Replicated Block Device support"
> > +	select INET
> > +	select PROC_FS
> > +	select CONNECTOR
> > +	select CRYPTO
> > +	select CRYPTO_HMAC
>
> Have you double checked that these symbols are supposed to be 'selected'?
> If they:
> - have dependencies
> - have a prompt
> then they most likely are not.
>

Right! Reading kconfig-language.txt makes one wiser ;)
I have changed them into dependencies.

> > @@ -0,0 +1,7 @@
> > +#CFLAGS_drbd_sizeof_sanity_check.o = -Wpadded # -Werror
>
> Commented out?
>

Removed.

> > +
> > +drbd-objs  :=	drbd_buildtag.o drbd_bitmap.o drbd_proc.o \
> > +		drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o \
> > +		lru_cache.o drbd_main.o drbd_strings.o drbd_nl.o
>
> Please use:
> drdb-y := drbd_buildtag.o drbd_bitmap.o drbd_proc.o
> ...
>
> And my personal taste favours:
> drdb-y := ...
> drdb-y += ...
>

Ok and ok, following your taste.

Thanks for those helpful hints!

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

