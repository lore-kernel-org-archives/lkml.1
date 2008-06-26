Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbYFZOjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbYFZOjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYFZOjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:39:05 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33082 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYFZOjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:39:04 -0400
Date: Thu, 26 Jun 2008 17:36:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 07/60] microblaze_v4: Support for semaphores
Message-ID: <20080626143652.GD30954@cs181140183.pp.htv.fi>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-2-git-send-email-monstr@seznam.cz> <1214483429-32360-3-git-send-email-monstr@seznam.cz> <1214483429-32360-4-git-send-email-monstr@seznam.cz> <1214483429-32360-5-git-send-email-monstr@seznam.cz> <1214483429-32360-6-git-send-email-monstr@seznam.cz> <1214483429-32360-7-git-send-email-monstr@seznam.cz> <1214483429-32360-8-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1214483429-32360-8-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:29:36PM +0200, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  include/asm-microblaze/semaphore.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-microblaze/semaphore.h
> 
> diff --git a/include/asm-microblaze/semaphore.h b/include/asm-microblaze/semaphore.h
> new file mode 100644
> index 0000000..d9b2034
> --- /dev/null
> +++ b/include/asm-microblaze/semaphore.h
> @@ -0,0 +1 @@
> +#include <linux/semaphore.h>

In -next all asm/semaphore.h headers gained a
  #warning Use linux/semaphore.h, not asm/semaphore.h
and the number of asm/semaphore.h is approaching zero.

You can simply drop this patch.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

