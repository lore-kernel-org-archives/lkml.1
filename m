Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYKHA25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYKHA25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYKHA2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:28:48 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:54330 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYKHA2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:28:48 -0500
Date: Sat, 8 Nov 2008 01:31:26 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, eric.y.miao@gmail.com
Subject: Re: [PATCH] mfd: da903x: fix event masking for da9030
Message-ID: <20081108003126.GA5993@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1225970631-15451-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225970631-15451-1-git-send-email-mike@compulab.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 01:23:51PM +0200, Mike Rapoport wrote:
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Thanks Mike, applied to my for-linus branch.

Cheers,
Samuel.

> ---
>  drivers/mfd/da903x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index b57326a..0b5bd85 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -267,7 +267,7 @@ static int da9030_mask_events(struct da903x_chip *chip, unsigned int events)
>  {
>  	uint8_t v[3];
>  
> -	chip->events_mask &= ~events;
> +	chip->events_mask |= events;
>  
>  	v[0] = (chip->events_mask & 0xff);
>  	v[1] = (chip->events_mask >> 8) & 0xff;
> -- 
> 1.5.6.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
