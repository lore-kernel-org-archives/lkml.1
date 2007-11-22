Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXKVCss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXKVCss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbXKVCqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:46:21 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:36312 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbXKVCqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:46:18 -0500
Date: Thu, 22 Nov 2007 11:46:21 +0900 (JST)
Message-Id: <20071122.114621.02788123.yoshfuji@linux-ipv6.org>
To: herbert@gondor.apana.org.au
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, yoshfuji@linux-ipv6.org
Subject: Re: [RFC/PATCH] SO_NO_CHECK for IPv6
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20071122023403.GA3409@gondor.apana.org.au>
References: <20071121.222051.94402865.yoshfuji@linux-ipv6.org>
	<4744CAA4.50102@garzik.org>
	<20071122023403.GA3409@gondor.apana.org.au>
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

In article <20071122023403.GA3409@gondor.apana.org.au> (at Thu, 22 Nov 2007 10:34:03 +0800), Herbert Xu <herbert@gondor.apana.org.au> says:

> On Wed, Nov 21, 2007 at 07:17:40PM -0500, Jeff Garzik wrote:
> >
> > For those interested, I am dealing with a UDP app that already does very 
> > strong checksumming and encryption, so additional software checksumming 
> > at the lower layers is quite simply a waste of CPU cycles.  Hardware 
> > checksumming is fine, as long as its "free."
> 
> No matter how strong your underlying checksumming is it's not
> going to protect the IPv6 header is it :)

In that sense, we should use AH.

--yoshfuji
