Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbXHVTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbXHVTyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbXHVTyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:54:10 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4293 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760013AbXHVTyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:54:09 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: 2.6.23-rc3-mm1: net/wireless/rt2x00mac.c build failure
Date: Wed, 22 Aug 2007 21:54:02 +0200
User-Agent: KMail/1.9.7
Cc: John Linville <linville@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222116.22386.m.kozlowski@tuxland.pl> <200708222131.24882.IvDoorn@gmail.com>
In-Reply-To: <200708222131.24882.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708222154.03663.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   CC [M]  drivers/net/wireless/rt2x00mac.o
> > drivers/net/wireless/rt2x00mac.c: In function `rt2x00mac_tx_rts_cts':
> > drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 2 of `ieee80211_ctstoself_get' makes pointer from integer without a cast
> > drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 3 of `ieee80211_ctstoself_get' makes integer from pointer without a cast
> > drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 4 of `ieee80211_ctstoself_get' makes pointer from integer without a cast
> > drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 5 of `ieee80211_ctstoself_get' from incompatible pointer type
> > drivers/net/wireless/rt2x00mac.c:61: error: too many arguments to function `ieee80211_ctstoself_get'
> > drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 2 of `ieee80211_rts_get' makes pointer from integer without a cast
> > drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 3 of `ieee80211_rts_get' makes integer from pointer without a cast
> > drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 4 of `ieee80211_rts_get' makes pointer from integer without a cast
> > drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 5 of `ieee80211_rts_get' from incompatible pointer type
> > drivers/net/wireless/rt2x00mac.c:65: error: too many arguments to function `ieee80211_rts_get'
> > make[3]: *** [drivers/net/wireless/rt2x00mac.o] Error 1
> > make[2]: *** [drivers/net/wireless] Error 2
> > make[1]: *** [drivers/net] Error 2
> > make: *** [drivers] Error 2
> 
> This has been fixed for quite some time already.
> John, I can't check this myself now, but which rt2x00
> patches have gone into the -mm tree? Since I believe
> the patch that changed ieee80211_ctstoself_get was
> followed by a patch to fix rt2x00 within the same series...

Ok. Thanks. What about this one?

  CC [M]  drivers/net/wireless/zd1211rw-mac80211/zd_mac.o
drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: In function `zd_op_erp_ie_changed':
drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: `IEEE80211_ERP_CHANGE_PREAMBLE' undeclared (first use in this function)
drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: (Each undeclared identifier is reported only once
drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: for each function it appears in.)
drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: At top level:
drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: error: unknown field `erp_ie_changed' specified in initializer
drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: warning: initialization from incompatible pointer type
make[4]: *** [drivers/net/wireless/zd1211rw-mac80211/zd_mac.o] Error 1
make[3]: *** [drivers/net/wireless/zd1211rw-mac80211] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Regards,

	Mariusz
