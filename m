Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbXLQUaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbXLQUaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXLQU35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:29:57 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4960 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753763AbXLQU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:29:56 -0500
Date: Mon, 17 Dec 2007 21:29:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: eric.y.miao@gmail.com, linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       bgardner@wabtec.com
Subject: Re: [PATCH 2.6.24-rc5-mm 3/3] gpiolib: obsolete  
 drivers/i2c/chips/pca9539.c
Message-ID: <20071217212953.260f7826@hyperion.delvare>
In-Reply-To: <20071217180953.1BB8E16AF21@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com>
	<20071216204214.01fd7a16@hyperion.delvare>
	<f17812d70712162233h759432a9i15b8e12d1a5fb828@mail.gmail.com>
	<20071217180953.1BB8E16AF21@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 17 Dec 2007 10:09:53 -0800, David Brownell wrote:
> > Date: Mon, 17 Dec 2007 14:33:27 +0800
> > From: "eric miao" <eric.y.miao@gmail.com>
> >
> > for the following reasons:
> >
> > 1. there is currently no known users of this driver
> >
> > 2. the functionality of this driver is well supported with the recent
> >    proposed drivers/gpio/pca9539.c, using GPIO_LIB
> >
> > Signed-off-by: eric miao <eric.miao@marvell.com>
> > Acked-by: Ben Gardner <bgardner@wabtec.com>
> > ---
> >  Documentation/i2c/chips/pca9539 |   47 --------
> >  drivers/i2c/chips/Kconfig       |   10 --
> >  drivers/i2c/chips/Makefile      |    1 -
> >  drivers/i2c/chips/pca9539.c     |  196 ----------------------------------
> 
> Jean, do you sign off on this?  In any case I think this should
> be going through your I2C patches.
> 
> I'd be a trifle uneasy just deleting this, because it's possible
> there are *unknown* users ... and also because nobody's yet done
> a userspace interface to the gpiolib infrastructure.  (It seems
> to be the usual case of nobody wanting such a thing quite enough
> to write the code.)
> 
> I'd be more comfortable marking it as obsolete and flagging it
> for removal a release or two after Eric's new version merges ...
> though maybe that's just paranoia.

I'm fine with this and I agree that it would be safer, however please
note that both drivers are mutually exclusive because they have the
same name, meaning that deprecating the old driver is not enough, you
also need Kconfig magic to make sure that both drivers aren't built at
the same time. Or alternatively the old driver could be renamed... I
don't really care myself, I'll take whatever patch you or Eric submit.

-- 
Jean Delvare
