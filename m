Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZEHVkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZEHVkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZEHVjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:39:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39737
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbZEHVjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:39:51 -0400
Date: Fri, 08 May 2009 14:39:47 -0700 (PDT)
Message-Id: <20090508.143947.207466029.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ipconfig: handle case of delayed DHCP server
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A049C6B.9070000@nortel.com>
References: <4A049C6B.9070000@nortel.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Fri, 08 May 2009 14:56:11 -0600

> 
> +	/* Is it a reply for the device we are configuring? */
> +	if (b->xid != ic_dev_xid) {
> +		if (net_ratelimit())
> + printk(KERN_ERR "DHCP/BOOTP: Ignoring delayed packet \n");
> +		goto drop_unlock;

Please don't use such odd indentation for this printk
statement.
