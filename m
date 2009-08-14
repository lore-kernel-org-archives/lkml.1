Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZHNCAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZHNCAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZHNCAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:00:09 -0400
Received: from ru.mvista.com ([213.79.90.228]:23340 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754292AbZHNCAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:00:08 -0400
Date: Fri, 14 Aug 2009 06:00:08 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 3/5] power_supply: Add driver for the PMU on WM831x
 PMICs
Message-ID: <20090814020008.GA5238@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1249922635-31864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249922635-31864-3-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1249922635-31864-3-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 05:43:53PM +0100, Mark Brown wrote:
> The WM831x PMICs provide power path management from three sources:
> a wall supply, USB and a battery with integrated charger. They also
> provide an additional backup supply with integrated for maintaining
> always on functionality such as the RTC and monitoring of power
> switches.
> 
> After some initial configuration at startup the device operates
> autonomously, the driver simply provides reporting of the current
> state.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I don't see the rest of the series, so I assume this patch
depends on some other patches. So, feel free to merge it through
your tree.

Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>


Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
