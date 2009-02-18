Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZBRMQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZBRMQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZBRMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:16:22 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55145 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZBRMQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:16:22 -0500
Subject: Re: [PATCH] leds: introduce lp5521 led driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1234794951-17171-1-git-send-email-felipe.balbi@nokia.com>
References: <1234794951-17171-1-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 12:18:13 +0000
Message-Id: <1234959493.5332.23.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 16:35 +0200, Felipe Balbi wrote:
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> new file mode 100644
> index 0000000..455da20
> --- /dev/null
> +++ b/drivers/leds/leds-lp5521.c
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/leds.h>
> +#include <linux/mutex.h>
> +#include <linux/workqueue.h>
> +#include <linux/i2c/lp5521.h>

Testing shows the above header is missing so I'll have to drop this
until that header is added.

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

