Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYKMMDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYKMMDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYKMMDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:03:15 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:47577 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751631AbYKMMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:03:14 -0500
Date: Thu, 13 Nov 2008 15:03:12 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Greg KH <greg@kroah.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [PATCH] led: simplify led_trigger_register_simple
Message-ID: <20081113120312.GA30307@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1226545753-6640-1-git-send-email-me@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1226545753-6640-1-git-send-email-me@felipebalbi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 05:09:13AM +0200, Felipe Balbi wrote:
> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> We can make led_trigger_register_simple by returning a
> struct led_trigger *, instead of passing a struct led_trigger **
> as a parameter and changing it inside the function.
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Pierre Ossman <drzeus@drzeus.cx>
> Cc: Richard Purdie <rpurdie@linux.intel.com>
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---
> Note that I could only test ide, power_supply and mmc changes with my laptop.
> The other changes weren't tested.
> 
>  drivers/leds/led-triggers.c         |   25 ++++++++++++++---------
>  drivers/leds/ledtrig-ide-disk.c     |    6 ++++-
>  drivers/mmc/core/host.c             |    4 ++-
>  drivers/mtd/nand/nand_base.c        |    5 +++-
>  drivers/power/power_supply_leds.c   |   36 ++++++++++++++++++++++++++++------

For power supply bits:

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks.
