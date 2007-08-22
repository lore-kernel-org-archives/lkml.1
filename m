Return-Path: <linux-kernel-owner+w=401wt.eu-S1763957AbXHVTXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763957AbXHVTXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbXHVTXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:23:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:20545 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbXHVTXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=LZvmjiqb76Cjqy90HfKu3k9CaP7onEBSW388vvh9smwrWIu2XWmVBEDO5YSoAN1vPz8j5ARwjk4MW3/FvoSIIlIjFUXQUXhtBcmKyBiBBL/XPWiR9xlIukyJSOI0i4uW3sSRAPJWH4thM7lBJACCsBPKv6DcoAEMOkLjh3oS4eY=
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: 2.6.23-rc3-mm1: net/wireless/rt2x00mac.c build failure
Date: Wed, 22 Aug 2007 21:31:24 +0200
User-Agent: KMail/1.9.7
Cc: John Linville <linville@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222116.22386.m.kozlowski@tuxland.pl>
In-Reply-To: <200708222116.22386.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708222131.24882.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>   CC [M]  drivers/net/wireless/rt2x00mac.o
> drivers/net/wireless/rt2x00mac.c: In function `rt2x00mac_tx_rts_cts':
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 2 of `ieee80211_ctstoself_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 3 of `ieee80211_ctstoself_get' makes integer from pointer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 4 of `ieee80211_ctstoself_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 5 of `ieee80211_ctstoself_get' from incompatible pointer type
> drivers/net/wireless/rt2x00mac.c:61: error: too many arguments to function `ieee80211_ctstoself_get'
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 2 of `ieee80211_rts_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 3 of `ieee80211_rts_get' makes integer from pointer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 4 of `ieee80211_rts_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 5 of `ieee80211_rts_get' from incompatible pointer type
> drivers/net/wireless/rt2x00mac.c:65: error: too many arguments to function `ieee80211_rts_get'
> make[3]: *** [drivers/net/wireless/rt2x00mac.o] Error 1
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

This has been fixed for quite some time already.
John, I can't check this myself now, but which rt2x00
patches have gone into the -mm tree? Since I believe
the patch that changed ieee80211_ctstoself_get was
followed by a patch to fix rt2x00 within the same series...

Ivo
