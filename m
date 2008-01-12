Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbYAMAH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbYAMAH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 19:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYAMAHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 19:07:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:65206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYAMAHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 19:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jLuUiB6AogPBh+fk/Niwlhc1YBZosUE4+nvE74I71Sl5SLVJ+0X9QY0wQ3Znpeij1M7Ot7BvWH7lk8NJKO8SCBK4C2U4kPANd8juGKUD1xaY3ju4ONCv04l1ZgdoTDTI8M6+YCeH5KADXntby5Z+0bTk8m4pHZmB69cGmxwhs20=
Date: Sun, 13 Jan 2008 02:52:11 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] pda_power: add device_init_wakeup
Message-ID: <20080112235211.GA12105@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080109163952.GA29397@doriath.ww600.siemens.net> <20080112225016.GA24957@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080112225016.GA24957@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 01:50:16AM +0300, Dmitry Baryshkov wrote:
> Hi,
> 
> Please apply this patch. Otherwise pda_power can't generate wakeup
> events. I forgot this in the initial pda_power suspend/resume patch.
> 
> Add device_init_wakeup to init wakeup.

Thanks, folded into "pda_power: add suspend/resume support" patch.

FYI, I got it first time, just didn't have time to process. ;-)

> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> 
> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index d98622f..28360e8 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
> @@ -207,6 +207,8 @@ static int pda_power_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	device_init_wakeup(&pdev->dev, 1);
> +
>  	return 0;
>  
>  usb_irq_failed:

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
