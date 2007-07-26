Return-Path: <linux-kernel-owner+w=401wt.eu-S935470AbXGZSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935470AbXGZSeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933439AbXGZSeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:34:06 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:49321 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763128AbXGZSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:34:04 -0400
Date: Thu, 26 Jul 2007 13:34:52 -0500 (CDT)
Message-Id: <20070726.133452.78498553.yoshfuji@linux-ipv6.org>
To: djohnson+linux-kernel@sw.starentnetworks.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
       lksctp-developers@lists.sourceforge.net, sakkiped@starentnetworks.com,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv6: ipv6_addr_type() doesn't know about RFC4193
 addresses
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
References: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
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

Hello.

In article <18087.57717.495366.413571@zeus.sw.starentnetworks.com> (at Wed, 25 Jul 2007 19:49:09 -0400), Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com> says:

> ipv6_addr_type() doesn't check for 'Unique Local IPv6 Unicast
> Addresses' (RFC4193) and returns IPV6_ADDR_RESERVED for that range.

Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

I would say, it would be better to add IPV6_ADDR_UNICAST as well
for "reserved" addresses unless we have good reason not to do it,
anyway.

-- 
YOSHIFUJI Hideaki @ USAGI Project  <yoshfuji@linux-ipv6.org>
GPG-FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
