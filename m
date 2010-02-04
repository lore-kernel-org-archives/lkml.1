Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0BDVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:08:48 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65356 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0BDVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Oc6SIlQo+YquutyiBeb1tQ+1czRiDzMB8TtePqCdIvxBd7+SOn4kUrJVg/2LUl0KGW
         SOUH/nYi24o8ebKVHHoQCYSdOHhutxTtWE37rG7W8FqJa7X5wFDTjFNG4KLZ7AfQP3NF
         ce+n4udTfT+W0kPgdqvwtjLGlBd1gG0ug5nNs=
Date: Thu, 4 Feb 2010 22:09:56 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Ben Dooks <ben-linux@fluff.org>, Eric Miao <eric.miao@marvell.com>,
       Kristoffer Ericson <Kristoffer.Ericson@gmail.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/9] platform-drivers: move probe to .devinit.text in
 arch/arm
Message-Id: <20100204220956.7c192527.kristoffer.ericson@gmail.com>
In-Reply-To: <20100204205606.GA8659@doriath.ww600.siemens.net>
References: <20100203150850.GA28815@kroah.com>
	<1265313417-5568-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20100204205606.GA8659@doriath.ww600.siemens.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 23:56:06 +0300
Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> On Thu, Feb 04, 2010 at 08:56:49PM +0100, Uwe Kleine-König wrote:
> > A pointer to a probe callback is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> > 
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
> > Cc: Ben Dooks <ben-linux@fluff.org>
> > Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Cc: Eric Miao <eric.miao@marvell.com>
> > Cc: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
> > Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
> > Cc: Paul Sokolovsky <pmiscml@gmail.com>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> sharpsl_pm part:
> Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

jornada part:
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

> 
> -- 
> With best wishes
> Dmitry
> 


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
