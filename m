Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZJ0Hum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZJ0Hum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZJ0Hul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:50:41 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:39223 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532AbZJ0Huk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:50:40 -0400
Date: Tue, 27 Oct 2009 08:50:44 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add s390 drivers block
Message-ID: <20091027075044.GB4261@osiris.boeblingen.de.ibm.com>
References: <1256587351.1865.132.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256587351.1865.132.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 01:02:31PM -0700, Joe Perches wrote:
> There are currently 4 directories in drivers/s390
> (block, char, cio, kvm) without maintainers
> that could point to the s390 mailing list.
> 
> Add a block for all drivers/s390
> List status as "Odd Fixes"

Hmm.. that's not exactly what we want. The status for (nearly)
everything in drivers/s390 is "Supported". The drivers/kvm
directory should have been added to the
"KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" section.

I take your patch, change it and put it into Martin's queue.
Thanks.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index f40dcce..fe37ef3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4466,6 +4466,12 @@ W:	http://www.ibm.com/developerworks/linux/linux390/
>  S:	Supported
>  F:	arch/s390/
> 
> +S390 DRIVERS
> +L:	linux-s390@vger.kernel.org
> +W:	http://www.ibm.com/developerworks/linux/linux390/
> +S:	Odd Fixes
> +F:	drivers/s390/
> +
>  S390 NETWORK DRIVERS
>  M:	Ursula Braun <ursula.braun@de.ibm.com>
>  M:	Frank Blaschka <blaschka@linux.vnet.ibm.com>
> @@ -4480,6 +4486,7 @@ M:	Felix Beck <felix.beck@de.ibm.com>
>  M:	Ralph Wuerthner <ralph.wuerthner@de.ibm.com>
>  M:	linux390@de.ibm.com
>  L:	linux-s390@vger.kernel.org
> +W:	http://www.ibm.com/developerworks/linux/linux390/
>  S:	Supported
>  F:	drivers/s390/crypto/
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
