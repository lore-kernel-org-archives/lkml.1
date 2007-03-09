Return-Path: <linux-kernel-owner+w=401wt.eu-S2993089AbXCIJsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993089AbXCIJsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993092AbXCIJsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:48:24 -0500
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:2275 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993089AbXCIJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:48:23 -0500
Date: Fri, 9 Mar 2007 10:47:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Sonic Zhang" <sonic.adi@gmail.com>
Cc: "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070309104706.53ea82ba.khali@linux-fr.org>
In-Reply-To: <4e5ebad50703082004s6cd34ccbp34e6f8b2c2273389@mail.gmail.com>
References: <1173164058.31825.16.camel@roc-desktop>
	<20070306214301.GA5590@martell.zuzino.mipt.ru>
	<1173247078.28531.24.camel@roc-desktop>
	<20070307075822.53e53c42.khali@linux-fr.org>
	<1173261197.28531.60.camel@roc-desktop>
	<20070308102738.2ec69c60.khali@linux-fr.org>
	<4e5ebad50703082004s6cd34ccbp34e6f8b2c2273389@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007 12:04:59 +0800, Sonic Zhang wrote:
> On 3/8/07, Jean Delvare <khali@linux-fr.org> wrote:
> > i2c-core can emulate SMBus transactions using master_xfer, so in
> > general when you have a complete master_xfer implementation you do not
> > need to define a separate smbus_xfer function. This would save a lot of
> > code.
> 
> Actually the i2c-core can't emulate SMBus transactions using the
> master_xfer function, because the blackfin TWI controller provide
> hardware support to the SMBus transactions and the combination of
> master_xfer operations can't generate proper signal for SMBus.

Did you try? I can't think of any valid reason why it wouldn't work.
All SMBus transactions are compatible with I2C by definition.

Now performance might be better with dedicated code if the hardware
accelerate SMBus transactions, that's a different issue. If you prefer
to keep the smbus_xfer method for performance reasons, that's OK with
me. After all you're the one who will have to maintain the driver ;)

-- 
Jean Delvare
