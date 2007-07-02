Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbXGBH2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbXGBH2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 03:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXGBH2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 03:28:07 -0400
Received: from ee.oulu.fi ([130.231.61.23]:34578 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbXGBH2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 03:28:06 -0400
X-Greylist: delayed 1377 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2007 03:28:06 EDT
Date: Mon, 2 Jul 2007 10:05:06 +0300
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: howto disable vlantag in tg3
Message-ID: <20070702070506.GA8399@ee.oulu.fi>
References: <87zm2g6waa.fsf@samuel.flexserv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <87zm2g6waa.fsf@samuel.flexserv.de>
User-Agent: Mutt/1.4.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 04:19:57PM +0200, Daniel J. Priem wrote:
> Hi,
> the tg3 module automatically removes any incoming vlantags from packets.
> how can i stop this on 2.6.18?
> is there some hidden echo foo > /sys/...
> or modprobe options tg3 dontusetagbla?
I think it's the same thing as on the newer broadcom bnx2, which I ran into.
There's some new enterprise managmenent thingy, ASF, that gets confused if
there are vlan tags present -> the driver is setup to strip them out if that
feature is enabled.

There is a dos-based tool to disable that bit on the bnx2 hardware
(which gives you those vlan tags back, vlans do work, you just can't
see them with tcpdump etc.), you can probably find one for tg3 as well
from broadcom.

-- 
Pekka Pietikainen
