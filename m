Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbXK2Twi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbXK2Twi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXK2Tvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:51:53 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:36812 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933794AbXK2Tvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:51:51 -0500
Subject: Re: Peculiar out-of-sync boot log lines
From: Jon Masters <jonathan@jonmasters.org>
To: Nick Warne <nick@ukfsn.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071129193728.2f1c237e@linuxamd.linicks.net>
References: <20071129193728.2f1c237e@linuxamd.linicks.net>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 29 Nov 2007 14:51:11 -0500
Message-Id: <1196365871.6473.107.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-29 at 19:37 +0000, Nick Warne wrote:
> Hi all,
> 
> 2.6.23.9
> 
> I have noticed after applying Bart's patch to word93 blacklist my new
> DVD drive:
> 
> http://lkml.org/lkml/2007/10/23/475
> 
> I see now in logs (look at the hdd line:
> 
> [dmesg]
> hdc: 39876480 sectors (20416 MB) w/2048KiB Cache, CHS=39560/16/63,
> UDMA(66)
> hdc: cache flushes not supported
>  hdc: hdc1
> hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
> skipping word 93 validity check
> , UDMA(66)
> Uniform CD-ROM driver Revision: 3.20

Only very early in boot are you guaranteed for things to execute
sequentially, and for logs to look nice and pretty.

Jon.


