Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZFBIWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZFBIWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759093AbZFBIV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:21:57 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34411 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbZFBIV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:21:56 -0400
Subject: Re: [PATCH 10/10] ieee802154: add at86rf230/rf231 spi driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       slapin@ossfans.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
In-Reply-To: <200906021010.49613.hs4233@mail.mn-solutions.de>
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	 <69e28c910906010921r56cf7017gc858cb7ba819c385@mail.gmail.com>
	 <20090601203348.GC7143@doriath.ww600.siemens.net>
	 <200906021010.49613.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 10:21:33 +0200
Message-Id: <1243930893.3192.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Holger,

> > I thought about drivers/net as about ip (well, more or less)
> > network drivers. We have drivers/atm or drivers/bluetooth (and
> > bluetooth is 802.15.1...).
> 
> I actually like that this is drivers/bluetooth and not 
> drivers/ieee802151. Would you consider drivers/zigbee instead of 
> drivers/ieee802154 ???

I fully agree here.

Please use "zigbee" instead of "ieee*" names since that can become messy
and confusing. I know that in theory the IEEE part of ZigBee is more
low-level radio and could be used by non-ZigBee devices, but that is not
gonna happen anyway. Especially with Bluetooth Low Energy pushing into
the turf of ZigBee. So please use proper names and not confuse people
with IEEE numbers ;)

Regards

Marcel


