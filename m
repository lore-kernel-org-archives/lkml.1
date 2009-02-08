Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZBHORZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZBHORZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZBHORP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:17:15 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:43273 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbZBHORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:17:15 -0500
Message-ID: <498EE94C.3010803@f-seidel.de>
Date: Sun, 08 Feb 2009 15:16:44 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, w.sang@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
References: <498C3EEA.5060508@suse.de>	<20090208000553.059a0732@hyperion.delvare>	<498EDA18.1090300@f-seidel.de> <20090208144751.46184041@hyperion.delvare>
In-Reply-To: <20090208144751.46184041@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare schrieb:
> +	printk(KERN_DEBUG);
> 	for (i = 0; i < i2c->irqlogidx; i++)
> 		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
> 	printk("\n");

I changed it a bit to have the loglevel at the real beginning of the
line.

Thanks,
Frank

