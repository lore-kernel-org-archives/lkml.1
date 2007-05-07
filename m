Return-Path: <linux-kernel-owner+w=401wt.eu-S966242AbXEGS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966242AbXEGS5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966200AbXEGS5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:57:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:40529 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966197AbXEGS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FE94vkXNIV0gx08ZSqLg773uylzb/YxKLd32gOW4V+Wa7KwvgC3hzRP3HnjZBmZREpqUcnvNmOOZHCS1HZJHJTxvBw/2OPP6IwN/v5od6UDdTCSbGvvnuJhFSVPmDlqM/2zrCAS3Awt21+NAQLzoI0ZGxtX0r6IMh2yNE6wqz5I=
Message-ID: <a44ae5cd0705071157m241ec3c1k8c60aaf213a28166@mail.gmail.com>
Date: Mon, 7 May 2007 11:57:28 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: 2.6.21-mm1+hotfix -- Slab corruption -- Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[  118.442018] ieee80211_crypt: registered algorithm 'WEP'
[  118.514572] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  118.514664] Slab corruption: size-256 start=c6aabe98, len=256
[  118.514672] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[  118.514676] Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
[  118.514692] 000: 10 55 ac c6 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[  118.514715] Prev obj: start=c6aabd80, len=256
[  118.514721] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
[  118.514725] Last user: [<c01afd85>](crypto_alloc_instance+0x1d/0xc0)
[  118.514734] 000: e0 71 39 c0 80 6e 39 c0 88 bd aa c6 88 bd aa c6
[  118.514753] 010: 04 00 00 00 01 00 00 00 04 00 00 00 00 00 00 00
