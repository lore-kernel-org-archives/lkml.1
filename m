Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZHLU6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZHLU6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZHLU6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:58:01 -0400
Received: from ru.mvista.com ([213.79.90.228]:19077 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751900AbZHLU6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:58:01 -0400
Date: Thu, 13 Aug 2009 00:58:00 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Michael Barkowski <michaelbarkowski@ruggedcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
Message-ID: <20090812205800.GA27074@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
 <20090731004100.GB8371@oksana.dev.rtsoft.ru>
 <4A832A03.6020507@ruggedcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A832A03.6020507@ruggedcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 04:45:55PM -0400, Michael Barkowski wrote:
> Hello Anton,
> 
> Is m25p_probe now valid with dev.platform_data == NULL, for of platforms?
> 
> Then shouldn't you have the following change as well, near the end of
> the function?
> 
> -  	} else if (data->nr_parts)
> +  	} else if (data && data->nr_parts)
> 		dev_warn(&spi->dev, "ignoring %d default partitions on %s\n",
> 				data->nr_parts, data->name);
> 
> Or am I misunderstanding something?

Yeah, you missed this patch:
http://patchwork.kernel.org/patch/38179/


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
