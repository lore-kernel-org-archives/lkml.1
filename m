Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbZAMGVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbZAMGVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZAMGU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:20:59 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:5930 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZAMGU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:20:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=NS0HWKg8r3KcB1dzyTmK2fKyGKYMYJFKUj9gEhFLWE76dz9XEEuQ85VMFdn1CGp3he
         MmxPkk8fSTs+967L6hyRSSFnPLyhF6YGafu/6zGfP80rnHuLgHw15dBHS4nyL1dwtBq9
         12Q6x+avWYAko2oZsQdXjN/NK3PM4NtTeA+2k=
Date: Mon, 12 Jan 2009 22:20:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move corgi-keyboard's probe function to .devinit.text
Message-ID: <20090112221942.ZZRA012@mailhub.coreip.homeip.net>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org> <1231799107-20136-11-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231799107-20136-11-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:24:16PM +0100, Uwe Kleine-König wrote:
> A pointer to corgikbd_probe is passed to the core via
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

Applied, thank you Uwe.

-- 
Dmitry
