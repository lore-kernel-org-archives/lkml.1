Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXIRCZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXIRCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 22:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbXIRCZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 22:25:15 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:44083 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbXIRCZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 22:25:13 -0400
Date: Tue, 18 Sep 2007 11:26:44 +0900 (JST)
Message-Id: <20070918.112644.28694997.yoshfuji@linux-ipv6.org>
To: ytht.net@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] 2.6.22.6 NETWORKING [IPV4]: Always use source addr in
 skb to reply packet
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070917.192044.48396034.davem@davemloft.net>
References: <20070918021617.GA15540@router.lepton.home>
	<20070917.192044.48396034.davem@davemloft.net>
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
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070917.192044.48396034.davem@davemloft.net> (at Mon, 17 Sep 2007 19:20:44 -0700 (PDT)), David Miller <davem@davemloft.net> says:

> From: lepton <ytht.net@gmail.com>
> Date: Tue, 18 Sep 2007 10:16:17 +0800
> 
> > Hi,
> >   In some situation, icmp_reply and ip_send_reply will send
> >   out packet with the wrong source addr, the following patch
> >   will fix this.
> > 
> >   I don't understand why we must use rt->rt_src in the current
> >   code, if this is a wrong fix, please correct me.
> > 
> > Signed-off-by: Lepton Wu <ytht.net@gmail.com>
> 
> That the address is wrong is your opinion only :-)
> 
> Source address selection is a rather complex topic, and
> here we are definitely purposefully using the source
> address selected by the routing lookup for the reply.

And, if you do think something is "wrong", you need to describe it
in detail, at least.

--yoshfuji
