Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYCRJOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYCRJOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYCRJOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:14:38 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:54283 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYCRJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:14:37 -0400
Date: Tue, 18 Mar 2008 18:15:55 +0900 (JST)
Message-Id: <20080318.181555.105003756.yoshfuji@linux-ipv6.org>
To: ramirose@gmail.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] [IPV6] remove unused parameter (struct sock parameter)
 from ip6_route_output()
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <eb3ff54b0803180203h18cda4ceja6ae28033638d338@mail.gmail.com>
References: <eb3ff54b0803180203h18cda4ceja6ae28033638d338@mail.gmail.com>
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

NAK; I have a plan to use it in net-2.6.26 tree.

--yoshfuji

In article <eb3ff54b0803180203h18cda4ceja6ae28033638d338@mail.gmail.com> (at Tue, 18 Mar 2008 11:03:04 +0200), "Rami Rosen" <ramirose@gmail.com> says:

> Hi,
> This patch removes the struct sock parameter from ip6_route_output();
> looking at the ip6_route_output() implementation in net/ipv6/route.c
> will show immediately that it is not used in this method.
> 
> In fact, icmp.c and ip6_output.c are the only places in the kernel
> where the sk (struct sock) parameter passed to ip6_route_output() is not NULL;
> anyhow, as explained above, this parameter is unused; changing
> the ip6_route_output() prototype by omitting the struct sock parameter
> does not break anything.
> 
> 
> Regards,
> Rami Rosen
> 
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
