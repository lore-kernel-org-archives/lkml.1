Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXHZPuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXHZPuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXHZPuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:50:00 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:37627 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXHZPuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:50:00 -0400
Subject: Re: Linux 2.6.20.17
From: Marcel Holtmann <marcel@holtmann.org>
To: bb@kernelpanic.ru
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Willy Tarreau <wtarreau@hera.kernel.org>, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org
In-Reply-To: <46D198FE.70506@kernelpanic.ru>
References: <20070825153810.GA32619@hera.kernel.org>
	 <20070825110148.5fd59272.randy.dunlap@oracle.com>
	 <46D198FE.70506@kernelpanic.ru>
Content-Type: text/plain
Date: Sun, 26 Aug 2007 17:48:54 +0200
Message-Id: <1188143334.15402.243.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

> > I'm getting build errors:
> > 
> > x86_64 allyesconfig, allmodconfig:
> > 
> > drivers/ata/pata_atiixp.c:286: error: 'PCI_DEVICE_ID_ATI_IXP700_IDE' undeclared here (not in a function)
> > net/bluetooth/rfcomm/tty.c:275: error: 'struct rfcomm_dev' has no member named 'tty_dev'
> > net/bluetooth/rfcomm/tty.c:278: error: 'struct rfcomm_dev' has no member named 'tty_dev'
> 
> 
> After applying patch-2.6.20.17, I'm getting build errors either:
> 
> net/bluetooth/rfcomm/tty.c: In function `rfcomm_dev_add':
> net/bluetooth/rfcomm/tty.c:275: error: structure has no member named 
> `tty_dev'
> net/bluetooth/rfcomm/tty.c:278: error: structure has no member named 
> `tty_dev'
> make[3]: *** [net/bluetooth/rfcomm/tty.o] Error 1
> make[2]: *** [net/bluetooth/rfcomm] Error 2
> make[1]: *** [net/bluetooth] Error 2
> make: *** [net] Error 2

the device_move() support was introduced with 2.6.21 so it seems we have
a backport here that is not meant for this kernel.

Regards

Marcel


