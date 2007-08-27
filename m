Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXH0Bba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXH0Bba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 21:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbXH0BbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 21:31:23 -0400
Received: from 1wt.eu ([62.212.114.60]:2305 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbXH0BbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 21:31:23 -0400
Date: Mon, 27 Aug 2007 03:12:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: bb@kernelpanic.ru, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.20.17
Message-ID: <20070827011232.GA23159@1wt.eu>
References: <20070825153810.GA32619@hera.kernel.org> <20070825110148.5fd59272.randy.dunlap@oracle.com> <46D198FE.70506@kernelpanic.ru> <1188143334.15402.243.camel@violet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188143334.15402.243.camel@violet>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On Sun, Aug 26, 2007 at 05:48:54PM +0200, Marcel Holtmann wrote:
> Hi Boris,
> 
> > > I'm getting build errors:
> > > 
> > > x86_64 allyesconfig, allmodconfig:
> > > 
> > > drivers/ata/pata_atiixp.c:286: error: 'PCI_DEVICE_ID_ATI_IXP700_IDE' undeclared here (not in a function)
> > > net/bluetooth/rfcomm/tty.c:275: error: 'struct rfcomm_dev' has no member named 'tty_dev'
> > > net/bluetooth/rfcomm/tty.c:278: error: 'struct rfcomm_dev' has no member named 'tty_dev'
> > 
> > 
> > After applying patch-2.6.20.17, I'm getting build errors either:
> > 
> > net/bluetooth/rfcomm/tty.c: In function `rfcomm_dev_add':
> > net/bluetooth/rfcomm/tty.c:275: error: structure has no member named 
> > `tty_dev'
> > net/bluetooth/rfcomm/tty.c:278: error: structure has no member named 
> > `tty_dev'
> > make[3]: *** [net/bluetooth/rfcomm/tty.o] Error 1
> > make[2]: *** [net/bluetooth/rfcomm] Error 2
> > make[1]: *** [net/bluetooth] Error 2
> > make: *** [net] Error 2
> 
> the device_move() support was introduced with 2.6.21 so it seems we have
> a backport here that is not meant for this kernel.

Eventhough I tried to be very careful this time, I got it wrong for
these two patches affecting code I do not use :-(  I'll fix all
this mess ASAP in -18rc1.

Regards,
Willy

