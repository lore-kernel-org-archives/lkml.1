Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXKFFAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXKFFAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbXKFFAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:00:00 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:47347 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbXKFE77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:59:59 -0500
Date: Mon, 5 Nov 2007 23:58:22 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: a list of non-existent but included include/linux header files
In-Reply-To: <8bd0f97a0711052051v45856f6apfacd66ade1d47113@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711052355490.21645@localhost.localdomain>
References: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
 <8bd0f97a0711052051v45856f6apfacd66ade1d47113@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Mike Frysinger wrote:

> > (the only manual culling i did of the list was to remove
> > inclusions of autoconf.h and utsrelease.h -- i assumed those
> > weren't an issue for anyone.)
>
> should do the opposite ... nobody should be including
> linux/autoconf.h

ah, good point:

$ grep -r "<linux/autoconf.h>" *
arch/blackfin/mm/blackfin_sram.c:#include <linux/autoconf.h>
arch/blackfin/mach-common/interrupt.S:#include <linux/autoconf.h>
arch/mips/au1000/common/gpio.c:#include <linux/autoconf.h>
arch/m68knommu/lib/memcpy.c:#include <linux/autoconf.h>
drivers/char/mxser_new.c:#include <linux/autoconf.h>
drivers/char/mxser.c:#include <linux/autoconf.h>
drivers/ide/pci/delkin_cb.c:#include <linux/autoconf.h>
drivers/firmware/dmi-id.c:#include <linux/autoconf.h>
drivers/spi/spi.c:#include <linux/autoconf.h>
drivers/misc/fujitsu-laptop.c:#include <linux/autoconf.h>
drivers/misc/asus-laptop.c:#include <linux/autoconf.h>
drivers/misc/msi-laptop.c:#include <linux/autoconf.h>

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
