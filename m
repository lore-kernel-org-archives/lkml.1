Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbXHVUOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbXHVUOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761754AbXHVUOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:14:39 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2366 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760777AbXHVUOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:14:38 -0400
Date: Wed, 22 Aug 2007 15:58:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: net/wireless/rt2x00mac.c build failure
Message-ID: <20070822195814.GG2926@tuxdriver.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222116.22386.m.kozlowski@tuxland.pl> <200708222131.24882.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708222131.24882.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:31:24PM +0200, Ivo van Doorn wrote:

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

Andrew had a lot of problems working-out conflicts between wireless-dev
and net-2.6.24.  I have since taken steps to help with this, but I
think his pull was from before the wireless-dev rebase.  Hopefully the
next -mm will be better.

John
-- 
John W. Linville
linville@tuxdriver.com
