Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYGUSa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYGUSa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYGUSaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:30:16 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:50438 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYGUSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:30:14 -0400
In-Reply-To: <ada4p6j6w7w.fsf@cisco.com>
Subject: Re: [PATCH 1/7] drivers/infiniband: Release mutex in error handling code
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, general@lists.openfabrics.org,
       hal.rosenstock@gmail.com, Julia Lawall <julia@diku.dk>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       rolandd@cisco.com, sean.hefty@intel.com
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF524A7E58.50725540-ONC125748D.00654D93-C125748D.00657007@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Mon, 21 Jul 2008 20:28:59 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 21/07/2008 20:29:01
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland and Julia,
Looks good to me. Thanks for pointing this out.
Nam

Roland Dreier <rdreier@cisco.com> wrote on 21.07.2008 18:25:07:

>  > --- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
>  > +++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
>  > @@ -163,6 +163,7 @@ static int alloc_small_queue_page(struct
>  >
>  >  out:
>  >     ehca_err(pd->ib_pd.device, "failed to allocate small queue page");
>  > +   mutex_unlock(&pd->lock);
>  >     return 0;
>  >  }
>
> Thanks, looks obviously correct.  ehca guys, I will queue this for my
> next pull request to Linus; please let me know if you see a problem and
> want me to drop it.
>
>  - R.

