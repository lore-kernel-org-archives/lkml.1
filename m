Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYAKGXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYAKGXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYAKGXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:23:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46824
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbYAKGXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:23:21 -0500
Date: Thu, 10 Jan 2008 22:23:20 -0800 (PST)
Message-Id: <20080110.222320.247508342.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH] bluetooth : rfcomm tty BUG_ON() code fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080107054122.GA4502@darkstar.te-china.tietoenator.com>
References: <20080107054122.GA4502@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Mon, 7 Jan 2008 13:41:22 +0800

> 1) In tty.c the BUG_ON at line 115 will never be called, because the the before list_del_init in this same function.
>  115          BUG_ON(!list_empty(&dev->list));
> So move the list_del_init to rfcomm_dev_del 
> 
> 2) The rfcomm_dev_del could be called from diffrent path (rfcomm_tty_hangup/rfcomm_dev_state_change/rfcomm_release_dev),
> So add another BUG_ON when the rfcomm_dev_del is called more than one time.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Applied, thanks Dave.
