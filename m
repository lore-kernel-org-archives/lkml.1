Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbZAMJ5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbZAMJ5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZAMJ5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:57:42 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:43676 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZAMJ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:57:41 -0500
Subject: Re: [PATCH] move wm8400-regulator's probe function to .devinit.text
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1231799107-20136-60-git-send-email-u.kleine-koenig@pengutronix.de>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org>
	 <1231799107-20136-60-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jan 2009 09:57:38 +0000
Message-Id: <1231840658.4934.74.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 23:25 +0100, Uwe Kleine-König wrote:
> A pointer to wm8400_regulator_probe is passed to the core via
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

Applied.

Thanks

Liam

