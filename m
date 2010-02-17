Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab0BQHhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 02:37:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45508
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934078Ab0BQHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 02:37:06 -0500
Date: Tue, 16 Feb 2010 23:37:22 -0800 (PST)
Message-Id: <20100216.233722.59677659.davem@davemloft.net>
To: joe@perches.com
Cc: david-b@pacbell.net, gregkh@suse.de, tilman@imap.cc,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 2/2] drivers/net/usb: Use netif_<level>
 logging facilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <c9b38227b55aa3bb46728329bf5290063124f516.1266221693.git.joe@perches.com>
References: <20100212.123837.56526847.davem@davemloft.net>
	<c9b38227b55aa3bb46728329bf5290063124f516.1266221693.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 15 Feb 2010 00:25:12 -0800

> Convert from:
> 	if (netif_msg_<foo>(priv))
> 		dev_<level>(dev...
> to
> 	netif_<level>(priv, foo, dev...
> 
> Also convert a few:
> 
> 	if (i < REG_TIMEOUT) {
> 		etc...
> 		return ret;
>        }
> to
> 	if (i >= REG_TIMEOUT)
> 		goto fail;
> 	etc...
> 	return ret;
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
