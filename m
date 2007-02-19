Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXBSNwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXBSNwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbXBSNwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:52:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:11903 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXBSNwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aKoKkBTtg9qyMN+6FATue+BM/f9W0AfDR1k3skKveJBgZ175WQCVD54jVzCjlgD+JPYTblnSO+ngznY24L+HDhgWH25w6z2NJOf4YMO215nPGnezX7o+YGRIT1NeWY06FO4FgzWtU9+NssPrYzmNJ3GRCyvjsoib7ENMKdW2yV4=
Message-ID: <6bffcb0e0702190552r67f878csb5e5c49dfa7c050c@mail.gmail.com>
Date: Mon, 19 Feb 2007 14:52:21 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: [-mm patch] fix locking in __make_request (was Re: 2.6.20-mm2: Oops in generic_make_request)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mattia Dongili" <malattia@linux.it>,
       "Laurent Riffard" <laurent.riffard@free.fr>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <20070220130408.GB566@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	 <45D84F73.8060904@free.fr> <20070218175805.GB5567@inferi.kami.home>
	 <20070218114903.a8160301.akpm@linux-foundation.org>
	 <6bffcb0e0702181205v5755fc0es284c5be32f85d304@mail.gmail.com>
	 <20070220130408.GB566@slug>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederik,

On 20/02/07, Frederik Deweerdt <deweerdt@free.fr> wrote:
> Hi Michal,
>
> This seems to be a locking problem in __make_request, check_plug_merge()
> should be called with the q->queue_lock held.
> Could you try the following patch? It silenced the oops for me.

For me too, but Jens dislikes this patch.

>
> Regards,
> Frederik

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
