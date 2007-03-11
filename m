Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbXCKUwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbXCKUwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXCKUwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:52:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37232
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932143AbXCKUww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:52:52 -0400
Date: Sun, 11 Mar 2007 13:52:51 -0700 (PDT)
Message-Id: <20070311.135251.21926684.davem@davemloft.net>
To: bwalle@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initialise SAK member for each virtual console to
 prevent oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070311204137.GD12950@strauss.suse.de>
References: <20070311204137.GD12950@strauss.suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Walle <bwalle@suse.de>
Date: Sun, 11 Mar 2007 21:41:38 +0100

> This patch initialises the SAK member of the vc_cons variable on all virtual
> terminals, not only the first one.

No it doesn't

> --- linux-2.6.21-rc3.orig/drivers/char/vt.c
> +++ linux-2.6.21-rc3/drivers/char/vt.c
> @@ -724,6 +724,7 @@ int vc_allocate(unsigned int currcons)	/
>  		return -ENOMEM;
>  	    memset(vc, 0, sizeof(*vc));
>  	    vc_cons[currcons].d = vc;
> +	    /* INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK); */

The code is commented out, so it won't do anything.

Please review the patches you are about to send to the list,
thank you.
