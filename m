Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075Ab0BQHhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 02:37:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45501
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934010Ab0BQHg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 02:36:59 -0500
Date: Tue, 16 Feb 2010 23:37:14 -0800 (PST)
Message-Id: <20100216.233714.39181977.davem@davemloft.net>
To: joe@perches.com
Cc: david-b@pacbell.net, gregkh@suse.de, tilman@imap.cc,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 1/2] usbnet: Convert dev(dbg|err|warn|info)
 macros to netdev_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <48cb1d6445dceaa7043d1039ca775a8961020d88.1266221693.git.joe@perches.com>
References: <20100212.123837.56526847.davem@davemloft.net>
	<48cb1d6445dceaa7043d1039ca775a8961020d88.1266221693.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 15 Feb 2010 00:25:11 -0800

> These macros are too similar to the dev_<level> equivalents
> but take a usbnet * argument.  Convert them to the recently
> introduced netdev_<level> macros and remove the old macros.
> 
> The old macros had "\n" appended to the format string.
> Add the "\n" to the converted uses.
> 
> Some existing uses of the dev<foo> macros in cdc_eem.c
> probably mistakenly had trailing "\n".  No "\n" added there.
> 
> Fix net1080 this/other log message inversion.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
