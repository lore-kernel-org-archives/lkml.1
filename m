Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZC1Kon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZC1Kon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 06:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZC1Koe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 06:44:34 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:41316 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZC1Kod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 06:44:33 -0400
Date: Sat, 28 Mar 2009 11:43:39 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: [PATCH 09/58] move cobalt-lcd's probe function to .devinit.text
Message-ID: <20090328104339.GA17386@linux-mips.org>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-9-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238196439-16535-9-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 12:26:30AM +0100, Uwe Kleine-König wrote:

> A pointer to cobalt_lcdfb_probe is passed to the core via
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
> Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
> Cc: Antonino Daplas <adaplas@pol.net>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
