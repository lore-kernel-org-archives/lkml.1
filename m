Return-Path: <linux-kernel-owner+w=401wt.eu-S965404AbXC1JWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965404AbXC1JWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965418AbXC1JWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:22:49 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:35323 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965404AbXC1JWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:22:48 -0400
Date: Wed, 28 Mar 2007 18:23:34 +0900 (JST)
Message-Id: <20070328.182334.109744556.yoshfuji@linux-ipv6.org>
To: agoston@ripe.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: IPv6: Connection reset/timeout under heavy load
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <460A2BDB.6080200@ripe.net>
References: <4608E7CA.3090001@ripe.net>
	<20070327.194636.63219035.yoshfuji@linux-ipv6.org>
	<460A2BDB.6080200@ripe.net>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <460A2BDB.6080200@ripe.net> (at Wed, 28 Mar 2007 10:48:27 +0200), Agoston Horvath <agoston@ripe.net> says:

> YOSHIFUJI Hideaki / 吉藤英明 wrote:
> > Would you test with latest kernel, if possible, please?
> 
> For the archive: switching to 2.6.20.4 fixed this problem.

Thank you for your report.

I guess the following change will fix the issue for 2.6.16.y:
http://www.linux-ipv6.org/gitweb/gitweb.cgi?p=gitroot/yoshfuji/linux-2.6-fix.git;a=commit;h=33a79bba0cc2f197b46cc54182f94c31ff6ad334

I hope this patch will go in 2.6.16-stable...

Regards,

--yoshfuji
