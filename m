Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbXCEKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbXCEKo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXCEKo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:44:26 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37046
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbXCEKoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:44:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc2-mm1: drivers/net/wireless/ compile error
Date: Mon, 5 Mar 2007 11:41:36 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070305014724.GM3441@stusta.de>
In-Reply-To: <20070305014724.GM3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051141.37180.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 02:47, Adrian Bunk wrote:
> On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-mm2:
> >...
> >  git-wireless.patch
> >...
> >  git trees
> >...
> 
> Multiple copies of the same drivers are a problem:
> 
> <--  snip  -->
> 
> ...
>   LD      drivers/net/wireless/built-in.o
> drivers/net/wireless/mac80211/built-in.o: In function `zd_chip_switch_radio_on':
> (.text+0x303b8): multiple definition of `zd_chip_switch_radio_on'
> drivers/net/wireless/zd1211rw/built-in.o:(.text+0x1fc): first defined here
> drivers/net/wireless/mac80211/built-in.o: In function `bcm43xx_dma_tx_suspend':
> (.text+0x128b6): multiple definition of `bcm43xx_dma_tx_suspend'
> drivers/net/wireless/bcm43xx/built-in.o:(.text+0x17d94): first defined here
> ...
> make[4]: *** [drivers/net/wireless/built-in.o] Error 1

Sure. You can't compile bcm43xx and bcm43xx-d80211 into the kernel.
This is going to be fixed by ripping out bcm43xx when bcm43xx-d80211 is merged.

-- 
Greetings Michael.
