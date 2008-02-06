Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbYBFIxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbYBFIxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbYBFIxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:53:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759068AbYBFIxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:53:13 -0500
Date: Wed, 6 Feb 2008 00:53:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Remove capacity_level from list of sysfs
 attributes
Message-Id: <20080206005312.237d7336.akpm@linux-foundation.org>
In-Reply-To: <20080205161327.GA8628@vespa.holoscopio.com>
References: <20080205161327.GA8628@vespa.holoscopio.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 14:13:36 -0200 Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org> wrote:

> ---
>  drivers/power/power_supply_sysfs.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index d482484..13399d1 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -106,7 +106,6 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(energy_now),
>  	POWER_SUPPLY_ATTR(energy_avg),
>  	POWER_SUPPLY_ATTR(capacity),
> -	POWER_SUPPLY_ATTR(capacity_level),
>  	POWER_SUPPLY_ATTR(temp),
>  	POWER_SUPPLY_ATTR(temp_ambient),
>  	POWER_SUPPLY_ATTR(time_to_empty_now),

What is the reason for making this change?
