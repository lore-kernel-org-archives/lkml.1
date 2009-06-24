Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZFXOcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZFXOcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZFXOby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:31:54 -0400
Received: from ru.mvista.com ([213.79.90.228]:5450 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409AbZFXObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:31:53 -0400
Date: Wed, 24 Jun 2009 18:30:51 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Subject: Re: [PATCH 5/5] Revert "power_supply: remove capacity_level from
	list of sysfs attributes"
Message-ID: <20090624143051.GC9035@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090622234626.677cdab3@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090622234626.677cdab3@mycelium.queued.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:46:26PM -0400, Andres Salomon wrote:
> 
> This reverts commit 4cbc76eadf56399cd11fb736b33c53aec9caab8c.
> 
> This is part of the CAPACITY_LEVEL re-add.

The two patches (4/5 and 5/5) looks OK, but could you merge them
together? Title them "Re-add capacity_level ...".

And place them somewhere in the beginning of this series, i.e.
before 2/5 and 3/5. That way we can apply 1/5, 4/5, and 5/5,
without depending on 2/5 and 3/5.

Thanks,

> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> ---
>  drivers/power/power_supply_sysfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index fef37b2..d22d9c9 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -116,6 +116,7 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(energy_now),
>  	POWER_SUPPLY_ATTR(energy_avg),
>  	POWER_SUPPLY_ATTR(capacity),
> +	POWER_SUPPLY_ATTR(capacity_level),
>  	POWER_SUPPLY_ATTR(temp),
>  	POWER_SUPPLY_ATTR(temp_ambient),
>  	POWER_SUPPLY_ATTR(time_to_empty_now),
> -- 
> 1.5.6.5
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
