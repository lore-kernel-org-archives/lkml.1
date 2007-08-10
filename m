Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbXHJCNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbXHJCNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXHJCNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:13:19 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:54246 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbXHJCNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:13:18 -0400
Date: Fri, 10 Aug 2007 11:14:20 +0900 (JST)
Message-Id: <20070810.111420.29442251.yoshfuji@linux-ipv6.org>
To: davem@davemloft.net
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, adobriyan@sw.ru,
       netdev@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 04/10] sysctl: Fix neighbour table sysctls.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070809.184921.11594412.davem@davemloft.net>
References: <m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810.104710.28739250.yoshfuji@linux-ipv6.org>
	<20070809.184921.11594412.davem@davemloft.net>
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

In article <20070809.184921.11594412.davem@davemloft.net> (at Thu, 09 Aug 2007 18:49:21 -0700 (PDT)), David Miller <davem@davemloft.net> says:

> From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
> Date: Fri, 10 Aug 2007 10:47:10 +0900 (JST)
> 
> > I disagree.  It is bad to remove existing interface.
> > Ditto for other patches.
> 
> I think perhaps you misunderstand what Eric is doing.
> 
> sys_sysctl() isn't working properly for these cases and it is both a
> deprecated interface and not worth the pain of adding support
> in these cases.

Would you explain why it does not work properly
for those cases?

--yoshfuji
