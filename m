Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZLVXux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZLVXux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZLVXuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:50:51 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53656 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZLVXuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xyOU+Z9G1IaGPyv0VYgcKAeF7fdDGN0l/dwFnNeJJq02lRE/eKJ2pEQDcfyVwpNWg/
         MRR5hmQZTtC6R/NT2EwB9YGsbl9ml09sVCwLdtE67B2YK0ly7pusXUrQ1VamdAQDV6Py
         JCKdteuPcBxXF/LVxTiznCbW4tNLwvRDEQbOo=
MIME-Version: 1.0
In-Reply-To: <4B27DD2E.1020409@gmail.com>
References: <4B27D302.5060905@gmail.com>
	 <25e057c00912151047k436058ep2bcff69bdaedcc7a@mail.gmail.com>
	 <4B27DD2E.1020409@gmail.com>
Date: Tue, 22 Dec 2009 15:50:49 -0800
X-Google-Sender-Auth: 2537d1ca8f1fcdc2
Message-ID: <9929d2390912221550w1a75c948nf83cbeb490dd11fb@mail.gmail.com>
Subject: Re: [PATCH] e1000: Fix tests of unsigned in e1000_tx_map()
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:02, Roel Kluin <roel.kluin@gmail.com> wrote:
> The variables count and i are unsigned so the (<|>=) 0 tests do not work.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
>
> This should be all with this pattern.
> As before I wasn't able to test this patch, so please review.
>
>  drivers/net/e1000/e1000_main.c |   10 +++++-----
>  drivers/net/e1000e/netdev.c    |   10 +++++-----
>  drivers/net/igb/igb_main.c     |   10 +++++-----
>  drivers/net/igbvf/netdev.c     |   10 +++++-----
>  drivers/net/ixgb/ixgb_main.c   |   10 +++++-----
>  drivers/net/ixgbe/ixgbe_main.c |   10 +++++-----
>  6 files changed, 30 insertions(+), 30 deletions(-)
>

Thanks Roel, I will add this patch to my queue.  Sorry for the delayed
response, for some odd reason your email got filtered.

-- 
Cheers,
Jeff
