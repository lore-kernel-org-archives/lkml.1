Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbYEPClz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbYEPClz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYEPCln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:41:43 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:48767 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYEPClm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:41:42 -0400
Date: Fri, 16 May 2008 11:42:01 +0900 (JST)
Message-Id: <20080516.114201.99640435.yoshfuji@linux-ipv6.org>
To: wrs@pt.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       usagi-core@linux-ipv6.org
Subject: Re: TAHI IPv6 testing of kernel 2.6.20
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <OFAB0C1694.0B207957-ON8525744A.006A249F-8525744A.006A50C8@pt.com>
References: <OFAB0C1694.0B207957-ON8525744A.006A249F-8525744A.006A50C8@pt.com>
Organization: USAGI Project
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

In article <OFAB0C1694.0B207957-ON8525744A.006A249F-8525744A.006A50C8@pt.com> (at Thu, 15 May 2008 15:21:14 -0400), William Seppeler <wrs@pt.com> says:

> I'm currently testing a 2.6.20 kernel using Self_Test_1.4.14 (performing 
> Phase2 host testing - ipv6ready_p2_host).  It passes all tests except for 
> one.  I'm failing test: 
> 
>     v6LC_2_3_6_G - Redirected to Alternate Router: Invalid (Target Address 
> is Multicast) 

We did not have any issues at that moment, but well,
we have a patch from Brian Haley <brian.haley@hp.com>
(Commit-ID: bf0b48dfc368c07c42b5a3a5658c8ee81b4283ac)
to fix this specific issue.

--yoshfuji
