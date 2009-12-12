Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbZLLBps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbZLLBps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 20:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbZLLBpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 20:45:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56787
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757045AbZLLBpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 20:45:45 -0500
Date: Fri, 11 Dec 2009 17:45:51 -0800 (PST)
Message-Id: <20091211.174551.123151540.davem@davemloft.net>
To: stern@rowland.harvard.edu
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: usb_autopm_*() removal build failure...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These routines are referenced by code in drivers/net/usb/kaweth.c and
in a comment in drivers/net/wimax/i2400m/usb-tx.c

The former causes a build failure.

drivers/net/usb/kaweth.c: In function 'kaweth_open':
drivers/net/usb/kaweth.c:719: error: implicit declaration of function 'usb_autopm_enable'
  CC      lib/syscall.o
  CC [M]  drivers/net/tokenring/tmspci.o
  CC [M]  drivers/char/synclink_gt.o
make[3]: *** [drivers/net/usb/kaweth.o] Error 1
make[2]: *** [drivers/net/usb] Error 2
make[2]: *** Waiting for unfinished jobs....

Just FYI...
