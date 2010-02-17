Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0BQIEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 03:04:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36321
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934069Ab0BQIEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 03:04:09 -0500
Date: Wed, 17 Feb 2010 00:04:22 -0800 (PST)
Message-Id: <20100217.000422.246530855.davem@davemloft.net>
To: joe@perches.com
Cc: david-b@pacbell.net, gregkh@suse.de, tilman@imap.cc,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 1/2] usbnet: Convert dev(dbg|err|warn|info)
 macros to netdev_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100216.233714.39181977.davem@davemloft.net>
References: <20100212.123837.56526847.davem@davemloft.net>
	<48cb1d6445dceaa7043d1039ca775a8961020d88.1266221693.git.joe@perches.com>
	<20100216.233714.39181977.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had to revert this series, the build fails:

drivers/net/wireless/rndis_wlan.c: In function 'rndis_query_oid':
drivers/net/wireless/rndis_wlan.c:731: error: implicit declaration of function 'devdbg'
drivers/net/wireless/rndis_wlan.c: In function 'set_essid':
drivers/net/wireless/rndis_wlan.c:948: error: implicit declaration of function 'devwarn'
drivers/net/wireless/rndis_wlan.c: In function 'rndis_connect':
drivers/net/wireless/rndis_wlan.c:1796: error: implicit declaration of function 'deverr'
drivers/net/wireless/rndis_wlan.c: In function 'rndis_wlan_auth_indication':
drivers/net/wireless/rndis_wlan.c:2273: error: implicit declaration of function 'devinfo'
make[3]: *** [drivers/net/wireless/rndis_wlan.o] Error 1
make[3]: *** Waiting for unfinished jobs....
