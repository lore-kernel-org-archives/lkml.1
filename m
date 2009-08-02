Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZHBTa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZHBTa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZHBTa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:30:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44888
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbZHBTaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:30:25 -0400
Date: Sun, 02 Aug 2009 12:30:33 -0700 (PDT)
Message-Id: <20090802.123033.168343935.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: pcnet32@verizon.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com, corbet@lwn.net, eteo@redhat.com, julia@diku.dk
Subject: Re: [PATCH] pcnet32: VLB support fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907302317.52648.bzolnier@gmail.com>
References: <200907302317.52648.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 30 Jul 2009 23:17:52 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pcnet32: VLB support fixes
> 
> VLB support has been broken since at least 2004-2005 period as some
> changes introduced back then assumed that ->pci_dev is always valid,
> lets try to fix it:
> 
> - remove duplicated SET_NETDEV_DEV() call
> 
> - call SET_NETDEV_DEV() only for PCI devices
> 
> - check for ->pci_dev validity in pcnet32_open()
> 
> [ Alternatively we may consider removing VLB support but there would not
>   be much gain in it since an extra driver code needed for VLB support is
>   minimal and quite simple. ]
> 
> This takes care of the following entry from Dan's list:
> 
> drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Also applied, thanks.
