Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbXGVGWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbXGVGWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXGVGWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:22:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59891
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbXGVGWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:22:08 -0400
Date: Sat, 21 Jul 2007 23:22:07 -0700 (PDT)
Message-Id: <20070721.232207.26531557.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: Re: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070722061924.GP21668@ftp.linux.org.uk>
References: <20070722054356.GO21668@ftp.linux.org.uk>
	<20070721.225413.23605608.davem@davemloft.net>
	<20070722061924.GP21668@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jul 2007 07:19:24 +0100

> We probably ought to make drivers/sbus/char/rtc.c sparc32-only,
> then - AFAICS it simply won't be able to register misc device and that
> will be it.  ACK?

ACK.

> > 2) all the __sparc_v9__ crap is removed from drivers/char/rtc.c
> > 3) all the __sparc__ crap is changed to CONFIG_SPARC32 in same
> > 4) CONFIG_RTC is not longer allows on sparc64, only sparc32 with PCI
> 
> Umm...  OK, that takes care of sparc64 side of things, which is probably
> all we realistically care about.  Except that it still leaves broken sparc32
> defconfig - we have RTC=m, SUN_MOSTEK_RTC=m and kbuild won't deal with it...

That definitely needs to be fixed and I'm willing to entertain
any suggestion on how to deal with it.
