Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZC2BX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZC2BX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 21:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZC2BXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 21:23:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:19174 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZC2BXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 21:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oyJaT9oAdbuXMkcSvDmBMSeOQzJQHHTeRmM/vhKkfmIGq2q8HAE7XBRe3CFIJS/o4B
         p4vkI7CDjvAXtY2oEo1wwYWOo26bAbtGqi/vqEi9kY/TfL3cUZ6mXGYdKB5qttg1FQJO
         O161KE3A8PbJs09Z7JZfFkSh6tBsbO67wdEV0=
MIME-Version: 1.0
In-Reply-To: <20090328193839.GC5588@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-47-git-send-email-u.kleine-koenig@pengutronix.de>
	 <f17812d70903280232i12f4ce68h1acff0667212286c@mail.gmail.com>
	 <20090328193839.GC5588@pengutronix.de>
Date: Sun, 29 Mar 2009 09:23:46 +0800
Message-ID: <f17812d70903281823n13308520s527766e14af8c8ce@mail.gmail.com>
Subject: Re: [PATCH 47/58] move sharpsl-pm's probe function to .devinit.text
From: Eric Miao <eric.y.miao@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/29 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Sat, Mar 28, 2009 at 05:32:02PM +0800, Eric Miao wrote:
>> 2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> > A pointer to sharpsl_pm_probe is passed to the core via
>> > platform_driver_register and so the function must not disappear when the
>> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
>> > unbinding and binding a device to the driver via sysfs will result in an
>> > oops as does a device being registered late.
>> >
>> > An alternative to this patch is using platform_driver_probe instead of
>> > platform_driver_register plus removing the pointer to the probe function
>> > from the struct platform_driver.
>> >
>>
>> This one looks OK to me.
> I assume this is an Acked-by: you?
>

Acked-by: Eric Miao <eric.miao@marvell.com>

> Best regards
> Uwe
>
> --
> Pengutronix e.K.                              | Uwe Kleine-König            |
> Industrial Linux Solutions                    | http://www.pengutronix.de/  |
>



-- 
Cheers
- eric
