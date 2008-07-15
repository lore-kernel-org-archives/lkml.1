Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYGOFbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYGOFbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYGOFa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:30:56 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:6799
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbYGOFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:30:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQAAG3Te0jLrQkK/2dsb2JhbAAIrTk
X-IronPort-AV: E=Sophos;i="4.30,364,1212336000"; 
   d="scan'208";a="247543143"
Subject: Re: [PATCH] Add SPI over GPIO driver
From: Ben Nizette <bn@niasdigital.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>, openwrt-devel@lists.openwrt.org
In-Reply-To: <200807142109.13243.mb@bu3sch.de>
References: <200807142109.13243.mb@bu3sch.de>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 15 Jul 2008 15:30:51 +1000
Message-Id: <1216099851.4265.156.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-07-14 at 21:09 +0200, Michael Buesch wrote:
> This adds a driver that lets you drive an SPI bus over
> generic GPIO pins.

Right, this is where spi-gpio is, please disregard my question in the
mmc-spi-gpio thing thread, it was domestic blindness after all :-)

Looks good overall.  I'm not sure that it need pretend to be
hotpluggable though (i.e. the board info can be hardwired so there's no
need for the board setup callback).  I guess this is to integrate with
your "dynamically create an mmc over spi over gpio" thinggy in the other
thread.  As I said there, I'd prefer that this platform device is
treated like other platform devices and any dynamicness be introduced at
in a more generic way.

What problem are you solving (or whole in board support are you
plugging) in this dynamic plugging of MMCs?

Thanks,
	--Ben.


