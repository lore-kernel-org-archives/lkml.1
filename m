Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbZAMGVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbZAMGVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZAMGV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:21:26 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:58362 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZAMGVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:21:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=x2aP20IRm74BiVUMaQdMK1m4ZkSQ61FD8uIrih4rGjgdVbVAWYqxoH0uTJIp+bwoS0
         uHvbESz0RbzbIXjEva+5kXLaGtIqgERobsSdFJQnmuecsRWHHmZiy7WA046mndB8fn1t
         JZ5v5pihxnp7YHhyVj5JsZZEZ1iPRtkq0HsV4=
Date: Mon, 12 Jan 2009 22:20:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move corgi-ts's probe function to .devinit.text
Message-ID: <20090112222031.ZZRA012@mailhub.coreip.homeip.net>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org> <1231799107-20136-13-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231799107-20136-13-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:24:18PM +0100, Uwe Kleine-König wrote:
> A pointer to corgits_probe is passed to the core via
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

Applied as well.

-- 
Dmitry
