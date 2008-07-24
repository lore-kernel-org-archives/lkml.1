Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYGXHdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYGXHdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYGXHd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:33:27 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:6260 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYGXHd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:33:27 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-164.messagelabs.com!1216884803!6363799!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Thu, 24 Jul 2008 09:33:19 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: David Brownell <david-b@pacbell.net>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] add might_sleep() to all implementations of gpio_free
Message-ID: <20080724073319.GA12289@digi.com>
References: <200807230916.48056.david-b@pacbell.net> <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 24 Jul 2008 07:33:19.0861 (UTC) FILETIME=[8B86EA50:01C8ED5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Uwe Kleine-König wrote:
> According to Documentation gpio_free should only be called from task
> context.  To make this more explicit add a might_sleep.
I just now noticed that I forgot to include my changes to
arch/blackfin/kernel/bfin_gpio.c in my patch.
Will fix that when/if resending the patch.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
