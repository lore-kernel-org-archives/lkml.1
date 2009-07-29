Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZG2PNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZG2PNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZG2PNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:13:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50555 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbZG2PNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:13:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: drbd tree build failure
Date: Wed, 29 Jul 2009 17:13:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090729152933.47664b18.sfr@canb.auug.org.au> <20090729062058.GE4148@kernel.dk>
In-Reply-To: <20090729062058.GE4148@kernel.dk>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291713.09695.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009 08:20:58 Jens Axboe wrote:
> On Wed, Jul 29 2009, Stephen Rothwell wrote:
> > Hi Philipp,
> >
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> >
> > drivers/block/drbd/drbd_req.c: In function 'drbd_make_request_26':
> > drivers/block/drbd/drbd_req.c:1023: error: implicit declaration of
> > function 'bio_barrier' drivers/block/drbd/drbd_actlog.c: In function
> > '_drbd_md_sync_page_io': drivers/block/drbd/drbd_actlog.c:120: error:
> > implicit declaration of function 'bio_barrier'
> > drivers/block/drbd/drbd_main.c: In function 'drbd_send_dblock':
> > drivers/block/drbd/drbd_main.c:2373: error: implicit declaration of
> > function 'bio_barrier' drivers/block/drbd/drbd_main.c:2375: error:
> > implicit declaration of function 'bio_sync'
> >
> > Caused by commit d206aaff0c5ee065f382c626ea21c5166a3047a7 ("bio: first
> > step in sanitizing the bio->bi_rw flag testing") from the block tree.
> >
> > I applied the following patch for today.
>
> That fixup looks good, thanks Stephen.

Thanks,
I have commited that patch also to the drbd git tree. I think we have
now fixed all open issues (currently).

-phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

