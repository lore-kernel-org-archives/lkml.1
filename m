Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZCBQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZCBQRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZCBQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:17:06 -0500
Received: from cathcart.site5.com ([74.54.107.137]:35524 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZCBQRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:17:05 -0500
Message-ID: <49AC0677.7040102@compulab.co.il>
Date: Mon, 02 Mar 2009 18:16:55 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: dmitry.torokhov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Subject: Re: [PATCH RESEND] Input: wm97xx: add BTN_TOUCH event to wm97xx to
 use it with Android
References: <49ABE938.8040502@compulab.co.il> <20090302142838.GA23342@rakim.wolfsonmicro.main>
In-Reply-To: <20090302142838.GA23342@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

Mark Brown wrote:
> On Mon, Mar 02, 2009 at 04:12:08PM +0200, Mike Rapoport wrote:
>> Android expects BTN_TOUCH events when pen state changes. Add BTN_TOUCH
>> event reporting to allow use of wm97xx touchscreen controller with
>> Android devices.
> 
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> I'd still like to see more consistency over touchscreen drivers on this
> one, BTW - if we're doing this it should be done for all touchscreen
> drivers (either by updating the individual drivers or having the input
> core do it).  This isn't the only touchscreen driver that doesn't do
> BTN_TOUCH.

Most touchscreen drivers already have BTN_TOUCH event generation:

> git-grep -L BTN_TOUCH v2.6.29-rc6 drivers/input/touchscreen/
v2.6.29-rc6:drivers/input/touchscreen/Kconfig
v2.6.29-rc6:drivers/input/touchscreen/Makefile
v2.6.29-rc6:drivers/input/touchscreen/mainstone-wm97xx.c
v2.6.29-rc6:drivers/input/touchscreen/ucb1400_ts.c
v2.6.29-rc6:drivers/input/touchscreen/wm9705.c
v2.6.29-rc6:drivers/input/touchscreen/wm9712.c
v2.6.29-rc6:drivers/input/touchscreen/wm9713.c
v2.6.29-rc6:drivers/input/touchscreen/wm97xx-core.c

If there no objection I can make a similar patch for mainstone-wm97xx.c and ucb1400_ts.c



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.

