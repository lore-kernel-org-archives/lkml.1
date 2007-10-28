Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbXJ1Rhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbXJ1Rhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbXJ1Rh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:37:29 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:10489 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbXJ1Rh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:37:28 -0400
Date: Sun, 28 Oct 2007 13:33:26 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: Jean Delvare <khali@linux-fr.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071028173326.GM30546@jupiter.solarsys.private>
References: <20071017195439.GD3778@stusta.de> <20071017204508.GA32110@kos.to> <20071018133744.GC3526@jupiter.solarsys.private> <20071019143754.0aa4483b@hyperion.delvare> <20071024115034.GA5797@kos.to> <20071025022529.GF30546@jupiter.solarsys.private> <20071025114814.GA2452@kos.to> <20071026103647.78f44826@hyperion.delvare> <20071026111423.GA16559@kos.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026111423.GA16559@kos.to>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Riku Voipio <riku.voipio@iki.fi> [2007-10-26 14:14:23 +0300]:
> On Fri, Oct 26, 2007 at 10:36:47AM +0200, Jean Delvare wrote:
> > Patch looks correct, however it doesn't apply on top of Mark's tree. I
> > was able to get it to apply by reverting "(f75375s) fix pwm mode
> > setting" first, but then the build fails. Presumably the other f75375s
> > patches interact badly. Can you please respin this patch on top of
> > Mark's tree (i.e. on top the the 4 other f75375s patches you sent since
> > the -rc1 merge)? Thanks.
> 
> The surrounding code had wandered to another function, so it's suprising
> it applied at all. Here's respin.
> 
> -- 
> "rm -rf" only sounds scary if you don't have backups

> >From 4de69e3ab5b5833cddb503f0dcb2a3ccc2d5b328 Mon Sep 17 00:00:00 2001
> From: Riku Voipio <riku.voipio@movial.fi>
> Date: Fri, 26 Oct 2007 13:53:50 +0300
> Subject: [PATCH] hwmon (f75375s) fix buggy if() properly
> 
>  Fix value check in set_pwm_mode(). Instead of checking for
>  chip variant there, make pwmX_mode sysfs nodes only writable
>  on f75375 variant.
> 
> Signed-off-by: Riku Voipio <riku.voipio@movial.fi>
> ---
>  drivers/hwmon/f75375s.c |   19 ++++++++++++++++---
>  1 files changed, 16 insertions(+), 3 deletions(-)
> 

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

