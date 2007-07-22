Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbXGVGkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbXGVGkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXGVGjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:39:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36759
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbXGVGju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:39:50 -0400
Date: Sat, 21 Jul 2007 23:39:49 -0700 (PDT)
Message-Id: <20070721.233949.35357470.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: Re: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070722063511.GR21668@ftp.linux.org.uk>
References: <20070721.232207.26531557.davem@davemloft.net>
	<20070722063149.GQ21668@ftp.linux.org.uk>
	<20070722063511.GR21668@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jul 2007 07:35:11 +0100

> > Crude and simple way would be to add
> > 
> > config JS_RTC
> > 	tristate "JavaStation RTC"
> > 	depends on SPARC32 && PCI
> > 	<copy help from RTC with s/will be called rtc/will be called js-rtc>
> > 
> > in drivers/char/Kconfig, slap plain and simple !SPARC in RTC dependencies
> > and put
> > js-rtc-y = rtc.o
> > obj-$(JS_RTC) += js-rtc.o
> > in drivers/char/Makefile
> > 
> > Objections?
> 
> Oh, and s/CONFIG_RTC/CONFIG_JS_RTC/ in arch/sparc/defconfig, of course.

No objections.
