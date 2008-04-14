Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbYDNNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbYDNNug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYDNNu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:50:26 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:33518 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYDNNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:50:25 -0400
Date: Mon, 14 Apr 2008 22:52:09 +0900 (JST)
Message-Id: <20080414.225209.92939349.yoshfuji@linux-ipv6.org>
To: ramirose@gmail.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-2.6.26] [IPV6] Return NET_RX_DROP when a packet is
 dropped in ipv6_rcv().
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <eb3ff54b0804140615u3dd4549fie83ae6818c33beba@mail.gmail.com>
References: <eb3ff54b0804140615u3dd4549fie83ae6818c33beba@mail.gmail.com>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <eb3ff54b0804140615u3dd4549fie83ae6818c33beba@mail.gmail.com> (at Mon, 14 Apr 2008 16:15:54 +0300), "Rami Rosen" <ramirose@gmail.com> says:

> Hi,
> - The IPv6 handler for receiving packets is ipv6_rcv() in net/ipv6/ip6_input.c.
> It is called by netif_receive_skb() (net/core/dev.c)
> According to the documentation, the return value of netif_receive_skb() should
> be NET_RX_DROP when the packet is dropped; though this return value
> is usually not used (except maybe for congestion), this patch fixes the
> ipv6_rcv() to return NET_RX_DROP when the packet is dropped (note that
> NET_RX_DROP value **is not** 0 but 1; NET_RX_SUCCESS value is in fact	0).

Well yes, and I think we should fix other paths as well, right?
So, I'm going to defer this for now.

--yoshfuji
