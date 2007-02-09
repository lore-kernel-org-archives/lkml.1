Return-Path: <linux-kernel-owner+w=401wt.eu-S1422729AbXBIABo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422729AbXBIABo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbXBIABn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:01:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54406
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933225AbXBIABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:01:43 -0500
Date: Thu, 08 Feb 2007 16:01:42 -0800 (PST)
Message-Id: <20070208.160142.11599230.davem@davemloft.net>
To: andrew@walrond.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux header change breaks linux-atm userspace build
From: David Miller <davem@davemloft.net>
In-Reply-To: <200702082131.25192.andrew@walrond.org>
References: <200702082131.25192.andrew@walrond.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Walrond <andrew@walrond.org>
Date: Thu, 8 Feb 2007 21:31:25 +0000

> Sometime between 2.6.18.3 and 2.6.20, this change...
> 
> --- /include/linux/atmarp.h     2007-01-10 16:32:05.000000000 +0000
> +++ pkg/linux/include/linux/atmarp.h    2007-02-08 20:02:08.000000000 +0000
> @@ -34,7 +34,7 @@
>  struct atmarp_ctrl {
>         enum atmarp_ctrl_type   type;   /* message type */
>         int                     itf_num;/* interface number (if present) */
> -       uint32_t                ip;     /* IP address (act_need only) */
> +       __be32                  ip;     /* IP address (act_need only) */
>  };
> 
>  #endif
> 
> was introduced, but __be32 is undefined, so atmarp.h should include 
> linux/types.h

I'll fix this, thanks for reporting.
