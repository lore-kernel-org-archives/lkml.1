Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbZK0IHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbZK0IHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZK0IHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:07:47 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:34931 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZK0IHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:07:47 -0500
Message-ID: <4B0F88C4.9010206@gmail.com>
Date: Fri, 27 Nov 2009 09:07:32 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [patch] spitz: better voltage-to-percentage conversion
References: <20091127073119.GB1405@ucw.cz>
In-Reply-To: <20091127073119.GB1405@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 27 Nov 2009 09:07:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek a écrit :
> Old code has two huge tables... unfortunately those tables are simple
> linear relationships and wrong: li-ions do not behave like that.
> 
> Convert physical values to mV,mA,mOhm, add computation that makes
> sense for physical point of view, and provide tables based on
> measurements.
> 
> To get even better results, we should provide better battery_current
> estimate (taking backlight into account), and adjust adjust
> battery_resistance according to its age and temperature. 
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> 
> --- a/arch/arm/mach-pxa/corgi_pm.c	2009-11-23 20:48:26.000000000 +0100

> +typedef int miliamp_t;
> +typedef int miliohm_t;
> +typedef int milivolt_t;

milliamp, milliohm, millivolt ?

