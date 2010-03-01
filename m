Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0CAHCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 02:02:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43466
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab0CAHCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 02:02:24 -0500
Date: Sun, 28 Feb 2010 23:02:42 -0800 (PST)
Message-Id: <20100228.230242.172227997.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, marcel@holtmann.org
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100301164721.f8ce9fac.sfr@canb.auug.org.au>
References: <20100301164721.f8ce9fac.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Mar 2010 16:47:21 +1100

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> net/bluetooth/hci_sysfs.c: In function 'inquiry_cache_read':
> net/bluetooth/hci_sysfs.c:441: warning: the frame size of 4208 bytes is larger than 2048 bytes
> 
> Introduced by commit ca325f698996c1a0770a67f41e7dc97a007d8bc2
> ("Bluetooth: Convert inquiry cache to use debugfs instead of sysfs")
> which introduces a function with a 4096 char array on the stack.

Thanks Stephen, I'll look into this.
