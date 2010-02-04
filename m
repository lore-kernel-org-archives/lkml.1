Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab0BDUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:02:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51668
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932879Ab0BDUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:02:56 -0500
Date: Thu, 04 Feb 2010 12:03:09 -0800 (PST)
Message-Id: <20100204.120309.51395616.davem@davemloft.net>
To: s.L-H@gmx.de
Cc: hadi@cyberus.ca, gregkh@suse.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002042049.31582.s.L-H@gmx.de>
References: <201002041931.40493.s.L-H@gmx.de>
	<1265308725.4651.14.camel@bigi>
	<201002042049.31582.s.L-H@gmx.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Date: Thu, 4 Feb 2010 20:49:29 +0100

> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -490,6 +490,7 @@ enum
>  	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
>  	NET_IPV4_CONF_ARP_ACCEPT=21,
>  	NET_IPV4_CONF_ARP_NOTIFY=22,
> +	NET_IPV4_CONF_ACCEPT_LOCAL=23,
>  	NET_IPV4_CONF_SRC_VMARK=24,
>  	__NET_IPV4_CONF_MAX
>  };
> 
> isn't sufficient, 2.6.32.8-rc1 plus the suggested patch above fails to boot
> as well (this time on amd64):

Yeah you can't just add the sysctl value without filling in the
name string in net/ipv4/devinet.c like the rest of Patrick's
change did.

Maybe just using a value of 23 for NET_IPV4_CONF_SRC_VMARK
will work best, can you try that?

Thanks.
