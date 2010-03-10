Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0CJLUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:20:34 -0500
Received: from smtp.nokia.com ([192.100.122.230]:29266 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0CJLUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:20:32 -0500
Subject: Re: linux-next: build failure after merge of the wireless tree
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>
Cc: ext Stephen Rothwell <sfr@canb.auug.org.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Paasikivi Teemu.3 (EXT-Ixonos/Tampere)" 
	<ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <1268200397.10120.459.camel@wimaxnb.nmp.nokia.com>
References: <20100310143605.8a20d310.sfr@canb.auug.org.au>
	 <1268200397.10120.459.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 13:19:53 +0200
Message-ID: <1268219993.10194.82.camel@chilepepper>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2010 11:19:59.0983 (UTC) FILETIME=[9F3457F0:01CAC043]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 06:53 +0100, Oikarinen Juuso (Nokia-D/Tampere)
wrote:
> Thinking about it, the assumption is correct. The implementation can
> currently work only on ARM, as the wl1271 requires and out-of-band IRQ
> line which is currently implemented with GPIO's.
> 
> -Juuso
> 
> On Wed, 2010-03-10 at 04:36 +0100, ext Stephen Rothwell wrote:
> > Hi John,
> > 
> > After merging the wireless tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/net/wireless/wl12xx/wl1271_sdio.c:31:23: error: plat/gpio.h: No such file or directory
> > drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_sdio_raw_read':
> > drivers/net/wireless/wl12xx/wl1271_sdio.c:121: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> > drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_sdio_raw_write':
> > drivers/net/wireless/wl12xx/wl1271_sdio.c:144: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> > drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_probe':
> > drivers/net/wireless/wl12xx/wl1271_sdio.c:198: error: implicit declaration of function 'gpio_to_irq'
> > 
> > Caused by commit 5129dffebd4eab1749e63bb4a1b7abdc92903227 ("wl1271:
> > Initial SDIO implementation").  I assume this is only meant to be built
> > for arm?

I'll send a patch to fix this problem soon.  Sorry for the trouble.

-- 
Cheers,
Luca.

