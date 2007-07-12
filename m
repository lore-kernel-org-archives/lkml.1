Return-Path: <linux-kernel-owner+w=401wt.eu-S1763641AbXGLLv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763641AbXGLLv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 07:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXGLLvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 07:51:20 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:2804 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752954AbXGLLvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 07:51:19 -0400
Date: Thu, 12 Jul 2007 13:51:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled i2c-rpx removal
Message-ID: <20070712135139.317978c1@hyperion.delvare>
In-Reply-To: <20070711180348.02dfd257@hyperion.delvare>
References: <20070709145724.GC3492@stusta.de>
	<20070711180348.02dfd257@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Adrian,

On Wed, 11 Jul 2007 18:03:48 +0200, Jean Delvare wrote:
> On Mon, 9 Jul 2007 16:57:24 +0200, Adrian Bunk wrote:
> > This patch contains the scheduled removal of the i2c-rpx driver.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > ---
> > 
> >  Documentation/feature-removal-schedule.txt |    8 -
> >  Documentation/i2c/summary                  |    1 
> >  drivers/i2c/algos/Kconfig                  |    4 
> >  drivers/i2c/busses/Kconfig                 |    5 -
> >  drivers/i2c/busses/Makefile                |    1 
> >  drivers/i2c/busses/i2c-rpx.c               |  101 ---------------------
> >  6 files changed, 120 deletions(-)
> 
> I already have a patch doing this in my tree.
> 
> Also note that the entry in feature-removal-schedule.txt never made it
> to mainline (it was in -mm only), so it can't be removed.
> 
> In theory there is a driver rewrite in progress, so my plan is to
> include this removal patch into -mm for now, and send it to Linus only
> for 2.6.24 if I don't receive an acceptable driver meanwhile.

I've changed my mind. The new driver will be so much bigger and
different from the current i2c-rpx driver that there's hardly any
benefit in keeping the old driver around. So I'll push this cleanup
patch to Linus for 2.6.23.

-- 
Jean Delvare
