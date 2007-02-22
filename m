Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbXBVOLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbXBVOLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbXBVOLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:11:18 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:57101 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbXBVOLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:11:17 -0500
Date: Thu, 22 Feb 2007 23:11:24 +0900 (JST)
Message-Id: <20070222.231124.58336645.yoshfuji@linux-ipv6.org>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 2/7] cxgb3 - private ioctl cleanup
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <45DD917D.5010807@chelsio.com>
References: <45DD8DDA.8060303@chelsio.com>
	<20070222.213915.89824941.yoshfuji@linux-ipv6.org>
	<45DD917D.5010807@chelsio.com>
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

In article <45DD917D.5010807@chelsio.com> (at Thu, 22 Feb 2007 04:50:05 -0800), Divy Le Ray <divy@chelsio.com> says:

> > Even if you remove them, PLEASE DO NOT CHANGE THE VALUES,
> > unless you have very, very good reason.
:
> The cxgb3 driver has not yet appeared in a stable version of the linux 
> kernel.
> The odds of breaking an application using these private ioctls are 
> pretty slim.
> Since some cleanup was required, I chose not to let holes between the 
> values.

Even so, if I were you, I would not have changed them and
I would even try keeping compatibility with old (out-kernel)
drivers.

--yoshfuji
