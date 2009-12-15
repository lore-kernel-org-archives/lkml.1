Return-Path: <linux-kernel-owner+w=401wt.eu-S934161AbZLOXLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbZLOXLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbZLOXL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:11:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933806AbZLOXL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:11:26 -0500
Date: Tue, 15 Dec 2009 15:10:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: mmotm 2009-11-24-16-47 uploaded (gpio_max7301)
Message-Id: <20091215151045.0b9fdb4d.akpm@linux-foundation.org>
In-Reply-To: <20091215144643.30756c30.randy.dunlap@oracle.com>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
	<4B0DDDFE.5060600@xenotime.net>
	<20091215144306.2d3aeeff.akpm@linux-foundation.org>
	<20091215144643.30756c30.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 14:46:43 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 15 Dec 2009 14:43:06 -0800 Andrew Morton wrote:
> 
> > On Wed, 25 Nov 2009 17:46:38 -0800
> > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > akpm@linux-foundation.org wrote:
> > > > The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to
> > > > 
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > 
> > > > and will soon be available at
> > > > 
> > > >    git://git.zen-sources.org/zen/mmotm.git
> > > > 
> > > > It contains the following patches against 2.6.32-rc8:
> > > >
> > > > gpio-add-driver-for-max7300-i2c-gpio-extender.patch
> > > 
> > > This driver has build failures when CONFIG_I2C=m and
> > > MAX7301=y, MAX7301_I2C=y, MAX7301_SPI=y:
> > > 
> > > drivers/built-in.o: In function `max7301_i2c_write':
> > > max7301.c:(.text+0x2d9e): undefined reference to `i2c_smbus_write_byte_data'
> > > drivers/built-in.o: In function `max7301_i2c_read':
> > > max7301.c:(.text+0x2dc6): undefined reference to `i2c_smbus_read_byte_data'
> > > drivers/built-in.o: In function `max7301_init':
> > > max7301.c:(.init.text+0x42e): undefined reference to `i2c_register_driver'
> > > max7301.c:(.init.text+0x496): undefined reference to `i2c_del_driver'
> > > drivers/built-in.o: In function `max7301_exit':
> > > max7301.c:(.exit.text+0x14): undefined reference to `i2c_del_driver'
> > > 
> > > 
> > > This kconfig syntax:
> > > 
> > > config GPIO_MAX7301
> > >         tristate "Maxim MAX730x GPIO expander"
> > >         depends on I2C || SPI_MASTER
> > > 
> > > allows GPIO_MAX7301 to be y when SPI_MASTER=y and I2C=m.
> > > If you want to do that, you'll need to handle CONFIG_I2C=m somehow.
> > > 
> > 
> > fyi, I have this patch "on hold" due to this issue.
> 
> Wolfram sent a large replacement patch on Sun Dec. 13:
> Subject: [PATCH V4] gpio: add driver for MAX7300 I2C GPIO extender

So he did, thanks.

Wolfram, the V4 patch doesn't have a usable changelog.  Please send one
along sometime?

