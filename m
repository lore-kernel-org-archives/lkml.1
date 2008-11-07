Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbYKGNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbYKGNES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYKGNEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:04:04 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:15760 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYKGNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eNSM9OjdFp5t6TUCOuax4TjoLPJNxBcWMwC3SAOVva1zInjnN5Q0u8sT94HvKIGpc7
         kZec/FBjbGd3ptnnxLG3U/CAP0GYe/RR2bhLjnasnoMSPKsNwuYCEmtWLwtMS5xFyZzh
         I3+/bp7yNJXpe8ewWUkcXdkm6bFWhezfwX4HE=
Message-ID: <f17812d70811070458y445b795ap58047a7413d79180@mail.gmail.com>
Date: Fri, 7 Nov 2008 20:58:51 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Mike Rapoport" <mike@compulab.co.il>
Subject: Re: [PATCH] mfd: da903x: fix event masking for da9030
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org
In-Reply-To: <1225970631-15451-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225970631-15451-1-git-send-email-mike@compulab.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 7:23 PM, Mike Rapoport <mike@compulab.co.il> wrote:
>
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

Acked-by: Eric Miao <eric.miao@marvell.com>

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
>        uint8_t v[3];
>
> -       chip->events_mask &= ~events;
> +       chip->events_mask |= events;
>
>        v[0] = (chip->events_mask & 0xff);
>        v[1] = (chip->events_mask >> 8) & 0xff;
> --
> 1.5.6.4
>
>



-- 
Cheers
- eric
