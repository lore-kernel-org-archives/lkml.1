Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbYGAWlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbYGAWlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762506AbYGAWlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:41:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:49268 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760457AbYGAWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:41:21 -0400
Date: Wed, 2 Jul 2008 00:41:25 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add btgpio driver
Message-ID: <20080701224124.GA31299@ska.dandreoli.com>
Mail-Followup-To: linux-kernel <linux-kernel@vger.kernel.org>
References: <200807010206.38714.mb@bu3sch.de> <20080701010414.GA5279@ska.dandreoli.com> <20080701220601.GA31029@ska.dandreoli.com> <Pine.LNX.4.64.0807011508180.26330@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807011508180.26330@shark.he.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 03:09:38PM -0700, Randy.Dunlap wrote:
> On Wed, 2 Jul 2008, Domenico Andreoli wrote:
> 
> > On Tue, Jul 01, 2008 at 03:04:15AM +0200, Domenico Andreoli wrote:
> > > On Tue, Jul 01, 2008 at 02:06:38AM +0200, Michael Buesch wrote:
> > > > This adds the btgpio driver.
> > > > The purpose of the btgpio driver is to export all of the 24 GPIO pins
> > > > available on Brooktree 8xx chips to the kernel GPIO infrastructure.
> > > > 
> > > > This makes it possible to use a physically modified BT8xx card as
> > > > cheap digital GPIO card.
> > > > 
> > > > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > > 
> > > How one is supposed to test this driver? I am unable to switch on
> > > the GIPO lib support in my config. I tried also allyesconfig but no
> > > trace of gpio lib stuff.
> > 
> > Really, GPIO menu is no present anywhere. While searching for GPIO
> > finds stuff, I am unable to locate and select it. I am using 2.6.26-rc8.
> 
> For what $ARCH?  GPIO menu says this:
> 
> config HAVE_GPIO_LIB
> 	bool
> 	help
> 	  Platforms select gpiolib if they use this infrastructure
> 	  for all their GPIOs, usually starting with ones integrated
> 	  into SOC processors.
> 
> and then the arch-es that select HAVE_GPIO_LIB are these:
> 
> ./arch/powerpc/platforms/52xx/Kconfig:50:       select HAVE_GPIO_LIB
> ./arch/mips/Kconfig:803:        select HAVE_GPIO_LIB
> ./arch/avr32/Kconfig:90:        select HAVE_GPIO_LIB
> ./arch/avr32/Kconfig.orig:85:   select HAVE_GPIO_LIB
> ./arch/arm/Kconfig:257: select HAVE_GPIO_LIB
> ./arch/arm/Kconfig:396: select HAVE_GPIO_LIB
> ./arch/arm/Kconfig:426: select HAVE_GPIO_LIB
> ./arch/arm/Kconfig:466: select HAVE_GPIO_LIB
> ./arch/arm/Kconfig.orig:401:    select HAVE_GPIO_LIB
> 
> so are you using one of those arches?

ah.. this explains, i am using x86_64. my Kconfig-foo is still too young.

thanks,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
