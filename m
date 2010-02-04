Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab0BDU4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:56:16 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33555 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933468Ab0BDU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:56:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BrJTQrxTiAJwb5e2KIHeqSLEUCJMEf5BqMvqU26CaJjGt0MqM5saFlpp7iJghaXMWH
         TKK3XAGSTDDb8Zk6BcJwOXaEv0HLPE63yJX8Yo7E9F1sIT3BLJtsZFPuAuVZJlZuiJ6c
         BTMx0d97AFeP0mi9WF5Y0CoIGOjEZqpOwL4Ww=
Date: Thu, 4 Feb 2010 23:56:06 +0300
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Ben Dooks <ben-linux@fluff.org>, Eric Miao <eric.miao@marvell.com>,
       Kristoffer Ericson <Kristoffer.Ericson@gmail.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/9] platform-drivers: move probe to .devinit.text in
 arch/arm
Message-ID: <20100204205606.GA8659@doriath.ww600.siemens.net>
References: <20100203150850.GA28815@kroah.com>
 <1265313417-5568-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265313417-5568-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:56:49PM +0100, Uwe Kleine-König wrote:
> A pointer to a probe callback is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Eric Miao <eric.miao@marvell.com>
> Cc: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
> Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
> Cc: Paul Sokolovsky <pmiscml@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>

sharpsl_pm part:
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

-- 
With best wishes
Dmitry

