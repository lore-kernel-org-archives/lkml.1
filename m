Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZG3CMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZG3CMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 22:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZG3CMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 22:12:51 -0400
Received: from ru.mvista.com ([213.79.90.228]:30037 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751406AbZG3CMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 22:12:51 -0400
Date: Thu, 30 Jul 2009 06:12:50 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/7] spi: Add support for device table matching
Message-ID: <20090730021250.GA12001@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
 <20090729170457.GA4803@oksana.dev.rtsoft.ru>
 <20090729214446.GB1728@fluff.org.uk>
 <20090729223223.GA15280@oksana.dev.rtsoft.ru>
 <20090729224050.GA17902@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090729224050.GA17902@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 02:40:50AM +0400, Anton Vorontsov wrote:
[...]
> - If you don't store "id" in the device struct, you'll have
>   to look up the device table twice (at first during bus->match(),
>   and second time in drivers' probe() hook, i.e.
>   probe(struct bus_dev *dev) {
>   	id = bus_get_devid(dev); /* here */
>   }

Hm... actually, we're doing this anyway, but in spi core.

So, doing something like spi_get_device_id() might be a good
idea.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
