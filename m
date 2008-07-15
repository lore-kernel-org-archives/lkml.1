Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYGOOoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYGOOoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYGOOoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:44:24 -0400
Received: from tim.rpsys.net ([194.106.48.114]:50035 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbYGOOoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:44:23 -0400
Subject: Re: [PATCH v2] leds: implement OpenFirmare GPIO LED driver
From: Richard Purdie <rpurdie@rpsys.net>
To: avorontsov@ru.mvista.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20080715142354.GA3296@polina.dev.rtsoft.ru>
References: <20080715123822.GA10893@polina.dev.rtsoft.ru>
	 <20080715124013.GA13086@polina.dev.rtsoft.ru>
	 <1216126470.5345.55.camel@dax.rpnet.com>
	 <20080715132438.GA26648@polina.dev.rtsoft.ru>
	 <1216128687.5345.61.camel@dax.rpnet.com>
	 <20080715142354.GA3296@polina.dev.rtsoft.ru>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:43:52 +0100
Message-Id: <1216133032.5345.73.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:23 +0400, Anton Vorontsov wrote:
> > Spell out openfirmware :). I initially had no idea "of == openfirmware"
> > and I suspect others won't either...
> 
> This would be unusually long name, that is
> 
> $ find . -iname '*openfirmware*' | wc -l
> 0
> 
> And in contrast:
> 
> drivers/video/offb.c
> drivers/video/nvidia/nv_of.c
> drivers/usb/host/ohci-ppc-of.c
> drivers/usb/host/ehci-ppc-of.c
> drivers/serial/of_serial.c
> drivers/mtd/maps/physmap_of.c
> ...
> 
> So, I think we should stick with the "of" for consistency, while
> confused users may consult with Kconfig for disambiguation.

The other cases don't have a gpio driver to confuse this new driver
with. Lets spell it out please, the filesystems can handle the extra
letters :).

Cheers,

Richard

