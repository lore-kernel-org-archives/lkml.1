Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbXHJC2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbXHJC2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXHJC2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:28:16 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:54264 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXHJC2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:28:14 -0400
Date: Fri, 10 Aug 2007 11:29:15 +0900 (JST)
Message-Id: <20070810.112915.63714468.yoshfuji@linux-ipv6.org>
To: ebiederm@xmission.com
Cc: davem@davemloft.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, adobriyan@sw.ru,
       netdev@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 04/10] sysctl: Fix neighbour table sysctls.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <m1odhg6sbv.fsf@ebiederm.dsl.xmission.com>
References: <20070809.184921.11594412.davem@davemloft.net>
	<20070810.111420.29442251.yoshfuji@linux-ipv6.org>
	<m1odhg6sbv.fsf@ebiederm.dsl.xmission.com>
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

In article <m1odhg6sbv.fsf@ebiederm.dsl.xmission.com> (at Thu, 09 Aug 2007 20:23:16 -0600), ebiederm@xmission.com (Eric W. Biederman) says:

> YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org> writes:
> 
> > Would you explain why it does not work properly
> > for those cases?
> 
> Mostly no appropriate strategy routine was setup to 
> report the data to the caller of sys_sysctl.

I assume that default strategy have been existing for it, no?!
Maybe, I do miss something...

--yoshfuji
