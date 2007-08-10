Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXHJCVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXHJCVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXHJCVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:21:32 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:54254 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbXHJCVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:21:31 -0400
Date: Fri, 10 Aug 2007 11:22:33 +0900 (JST)
Message-Id: <20070810.112233.90409216.yoshfuji@linux-ipv6.org>
To: ebiederm@xmission.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       adobriyan@sw.ru, netdev@vger.kernel.org, davem@davemloft.net,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 04/10] sysctl: Fix neighbour table sysctls.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
References: <m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
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

In article <m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com> (at Thu, 09 Aug 2007 18:56:09 -0600), ebiederm@xmission.com (Eric W. Biederman) says:

> 
> - In ipv6 ndisc_ifinfo_syctl_change so it doesn't depend on binary
>   sysctl names for a function that works with proc.
:

Well, retrans_time_ms and base_reachable_time_ms supercedes
retrans_time and base_reachable_time, we've warned for long
time for its deprecation.  So, maybe, it is time to remove
the old interfaces (retrans_time and base_reachable_time)
and simplify ndisc_ifinfo_syctl_change().

--yoshfuji
