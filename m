Return-Path: <linux-kernel-owner+w=401wt.eu-S1030285AbXCVJZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbXCVJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXCVJZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:25:59 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1560 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030285AbXCVJZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:25:58 -0400
Date: Thu, 22 Mar 2007 10:24:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Bryan Wu" <bryan.wu@analog.com>, "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Message-Id: <20070322102431.b55f7ecd.khali@linux-fr.org>
In-Reply-To: <8bd0f97a0703220112y7d6cef2ax612ea5ece3df9740@mail.gmail.com>
References: <1174471688.5648.56.camel@roc-desktop>
	<20070321202231.2eac1cf9.khali@linux-fr.org>
	<8bd0f97a0703212239n3edb9a44waa0994e3cffe48d8@mail.gmail.com>
	<20070322084806.8bf0f231.khali@linux-fr.org>
	<8bd0f97a0703220112y7d6cef2ax612ea5ece3df9740@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 04:12:37 -0400, Mike Frysinger wrote:
> it isnt obvious to me how to leverage the normal platform_device and
> resource structures to achieve moving the class out of the driver and
> into a boards file ... i'm perfectly happy doing this knowing what the
> correct direction to take things ... but i guess this gets us back to
> if no one is doing this yet and no one has any proposals, it's on our
> shoulders to get it resolved satisfactorily

I'd say: leave things as they are, if a problem arises, we'll see how
to fix it. By then, the new i2c driver model will be in mainline, which
will gives us a nicer way to address the problem.

> i might also argue (for fun) that some of the bus drivers arent doing
> it correctly ... they should implement support for the specific I2C
> implementation and then a different file for the specific
> [mother]board would contain the specific details

This sounds easy when you're in the embedded world. Now come and try to
support the literally thousands of different PC motherboard models out
there that way!

-- 
Jean Delvare
