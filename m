Return-Path: <linux-kernel-owner+w=401wt.eu-S1751067AbXCJTRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbXCJTRJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXCJTRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:17:09 -0500
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:3007 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbXCJTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:17:08 -0500
Date: Sat, 10 Mar 2007 20:15:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bitbanging i2c bus driver using the GPIO API
Message-Id: <20070310201531.512a13f8.khali@linux-fr.org>
In-Reply-To: <200703091130.13547.david-b@pacbell.net>
References: <200703090945.38880.david-b@pacbell.net>
	<11734661281633-git-send-email-hskinnemoen@atmel.com>
	<200703091130.13547.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007 11:30:12 -0800, David Brownell wrote:
> > --- a/include/linux/i2c-id.h
> > +++ b/include/linux/i2c-id.h
> > @@ -194,6 +194,7 @@
> >  #define I2C_HW_B_EM28XX		0x01001f /* em28xx video capture cards */
> >  #define I2C_HW_B_CX2341X	0x010020 /* Conexant CX2341X MPEG encoder cards */
> >  #define I2C_HW_B_INTELFB	0x010021 /* intel framebuffer driver */
> > +#define I2C_HW_B_GPIO		0x010022 /* Generic GPIO-based driver */
> 
> It'd be nice to completely abolish those IDs, starting by not
> adding new ones.  Especially, not adding unused ones!

I'm confident that we'll be able to get rid of the I2C device driver
IDs pretty soon thanks to your new i2c-core model, but I'm not sure if
we'll be able to get rid of I2C adapter drivers IDs that quickly. But I
agree with you, please let's not add new unused IDs.

-- 
Jean Delvare
