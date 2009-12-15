Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbZLOV6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbZLOV6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761246AbZLOV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:58:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761304AbZLOV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:58:08 -0500
Date: Tue, 15 Dec 2009 13:58:00 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Heinz Diehl <htd@fancy-poultry.org>, LKML <linux-kernel@vger.kernel.org>,
       martin.petersen@oracle.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
 mapper warnings
In-Reply-To: <20091209220749.GD8742@kernel.dk>
Message-ID: <alpine.DEB.2.01.0912151354350.3483@bogon.housecafe.de>
References: <200912091049.12604.borntraeger@de.ibm.com> <20091209212516.GA6206@fancy-poultry.org> <20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+P01wT4SpJeHWih9uuPCqOsB4EB9n9LUIh1EK
 nYKv60ulDTaMOyTXwmHJt+GeLPKCXbnXx25pGu6JqEu8TgqYEN
 VD6o53O9xFDoW/S1MvILw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 at 23:07, Jens Axboe wrote:
> Does this work?
> 
[...]
> +#if 0
>  	if (offset &&
>  	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
>  		t->discard_misaligned = 1;
>  		ret = -1;
>  	}
> +#endif

I can't tell: is this a purely cosmetical change or is it dangerous to run 
my DM devices without that patch? I'm trying to track mainline -git but 
the patch hasn't made into the tree yet, so I always have to manually
apply the patch - or can I just ignore the warning?

Christian.
-- 
BOFH excuse #153:

Big to little endian conversion error
