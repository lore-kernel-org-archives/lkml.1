Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbYGUJsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbYGUJsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYGUJsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:48:21 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:17829 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbYGUJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WmsWg0fA29K3rqVSquxWEEJwjlkxVDY7GWRxANPDfXLq9EvlDhkekusBV9IzuGuz9d
         fLJA8aR8a5XCyqqO01SbssDBZBJyBnsqIESXPIIq/17ValNhyOK/OVvSWKyaia4+Ch4C
         Cfq0nsP2n8C1n8f9uen3aWkdYFgnrPXGMvtv8=
Message-ID: <a4423d670807210248l1e2e6999ha462edc99002f964@mail.gmail.com>
Date: Mon, 21 Jul 2008 13:48:18 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [GIT]: Networking
Cc: adobriyan@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
In-Reply-To: <20080720.221106.201055562.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080720.181440.122144107.davem@davemloft.net>
	 <20080721024056.GA4800@martell.zuzino.mipt.ru>
	 <20080720.194856.92564555.davem@davemloft.net>
	 <20080720.221106.201055562.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David!

There is another problem on sparc64 and happymeal ethernet card.

when tring to up interface:

kernel BUG at net/core/dev.c:1328

ip(1090): Kernel bad sw trap 5

__netif_schedule
happy_meal_set_multicast
__dev_set_rx_mode
dev_set_rx_mode
dev_open
dev_change_flags
do_setlink
rtnl_newlink
rtnetlink_rcv_msg
netlink_rcv_skb
