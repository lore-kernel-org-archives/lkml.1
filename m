Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYL2VjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYL2VjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYL2VjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:39:10 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:55731 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbYL2VjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:39:09 -0500
X-Trace: 121306567/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.224/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.224
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.2 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEAFPSWElQLLDg/2dsb2JhbACBbLt/WJAChkQ
X-IronPort-AV: E=Sophos;i="4.36,297,1228089600"; 
   d="scan'208";a="121306567"
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA
 Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Mike Frysinger <vapier@gentoo.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <200812291636.36303.vapier@gentoo.org>
References: <1230578246.6496.25.camel@localhost.localdomain>
	 <200812291602.18572.vapier@gentoo.org>
	 <1230586215.6496.28.camel@localhost.localdomain>
	 <200812291636.36303.vapier@gentoo.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 21:38:34 +0000
Message-Id: <1230586714.6496.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 16:36 -0500, Mike Frysinger wrote:
> On Monday 29 December 2008 16:30:14 Adrian McMenamin wrote:
> > +static int __devexit remove_maple_mouse(struct device *dev)
> > +static struct maple_driver dc_mouse_driver = {
> > +	.drv = {
> > +		.remove = remove_maple_mouse,
> 
> does that really build warning free ?  usually you need __devexit_p() in the 
> .remove assignment ...
> -mike

Yep

adrian@bossclass:~/linux-2.6$ make ARCH=sh
CROSS_COMPILE=/home/adrian/dreamy-linux/buildroot/build_sh4/staging_dir/bin/sh4-linux- zImage modules -j4
scripts/kconfig/conf -s arch/sh/Kconfig
  CHK     include/linux/version.h
  SYMLINK include/asm -> include/asm-sh
make[1]: `include/asm-sh/machtypes.h' is up to date.
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      init/version.o
  CC      kernel/module.o
  LD      init/built-in.o
  CC [M]  drivers/input/mouse/maplemouse.o
  LD      kernel/built-in.o

