Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbXHJCAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbXHJCAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXHJCAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:00:43 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:54235 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474AbXHJCAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:00:42 -0400
Date: Fri, 10 Aug 2007 11:01:44 +0900 (JST)
Message-Id: <20070810.110144.117508471.yoshfuji@linux-ipv6.org>
To: ebiederm@xmission.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       adobriyan@sw.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 3/3] sysctl: Error on bad sysctl tables
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
References: <m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
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

In article <m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com> (at Thu, 09 Aug 2007 14:09:29 -0600), ebiederm@xmission.com (Eric W. Biederman) says:

> After going through the kernels sysctl tables several times it has
> become clear that code review and testing is just not effective in
> prevent problematic sysctl tables from being used in the stable
> kernel.  I certainly can't seem to fix the problems as fast as
> they are introduced.
:
> The biggest part of the code is the table of valid binary sysctl
> entries, but since we have frozen our set of binary sysctls this table
> should not need to change, and it makes it much easier to detect
> when someone unintentionally adds a new binary sysctl value.

I don't think everyone needs to have this code, so
it is better to make it configurable via
CONFIG_SYSCTL_DEBUG or something..., ...no?

--yoshfuji
