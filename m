Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbZFBIyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbZFBIyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZFBIya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:54:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:45928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZFBIy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IWGo4RqZmJx+E8ioNk3Wnbxpw9zpvnp2M7mdzMQsRjNDEiiZ0pVVaPkUIxlNWBLrmj
         ASyrlwXP2NIlVY8hz/rk0ockt+1C3RHN34A6MESC+Sm/GGYFy4gPcUVPjhR6+T+Vo5ZH
         //J/Yu9aThemy7uHjCh+tdQh0t7X+5cDPHj6A=
From: Florian Fainelli <florian@openwrt.org>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: =?utf-8?q?=D0=9E=D1=82=D0=B2=D0=B5=D1=82=3A_=5BPATCH_10/10=5D_ieee802154=3A?=
 =?utf-8?q?_add_at86rf230/rf231_spi?= driver
Date: Tue, 2 Jun 2009 10:46:51 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       linux-wireless@vger.kernel.org,
       =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       slapin@ossfans.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com> <bc64b4640906020129x4fe15e5en9d8e2cad1d86b236@mail.gmail.com> <1243931809.3192.68.camel@localhost.localdomain>
In-Reply-To: <1243931809.3192.68.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906021046.52681.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 02 June 2009 10:36:49 Marcel Holtmann, vous avez écrit :
> Hi Dmitry,
>
> > >> > I thought about drivers/net as about ip (well, more or less)
> > >> > network drivers. We have drivers/atm or drivers/bluetooth (and
> > >> > bluetooth is 802.15.1...).
> > >>
> > >> I actually like that this is drivers/bluetooth and not
> > >> drivers/ieee802151. Would you consider drivers/zigbee instead of
> > >> drivers/ieee802154 ???
> > >
> > > I fully agree here.
> > >
> > > Please use "zigbee" instead of "ieee*" names since that can become
> > > messy and confusing. I know that in theory the IEEE part of ZigBee is
> > > more low-level radio and could be used by non-ZigBee devices, but that
> > > is not gonna happen anyway. Especially with Bluetooth Low Energy
> > > pushing into the turf of ZigBee. So please use proper names and not
> > > confuse people with IEEE numbers ;)
> >
> > This gonna happen, as we are most probably going to implement 6lowpan
> > on top of our stack. 6lowpan is a way to encapsulate IPv6 frames into
> > IEEE 802.15.4 and has nothing in common with ZigBee. Moreover
> > ZigBee is a trademark with strict rules upon it's usage. Our lawyers are
> > currently investigating if it's possible to use this name in projects
> > like Linux kernel which are open-source, non-related to any project but
> > OTOH can be encapsulated in any commercial project.
> >
> > IEEE 802.15.4 is a term like IEEE 802.11. We do have mac80211,
> > we have had (until recently) ieee80211 dir, so why bother?
> >
> > For Bluetooth naming directories 'bluetooth' is logical, as 802.15.1
> > standard is a less known name, doesn't incorporate latest changes
> > from Bluetooth, etc.
>
> and so is IEEE 802.15.4 hence we propose using "zigbee" here. Using the
> mac80211 has historical reasons and 802.11 is a known name and even used
> on product marketing material. IEEE 802.15.4 is not. We are also using
> the term "wimax" and not its IEEE numbering.

Because you have an IEEE 802.15.4 PHY/MAC chip does not mean you want to do 
ZigBee on top of it and Dmitry explained that well. I would stick with the 
ieee802154 name here for that reason. If your drivers go in ZigBee, it means 
that your hardware implements parts of the ZigBee profiles, and that is not 
the case here.

The current Bluetooth implementation in the kernel deserves its name since 
drivers are implementing the HCI Bluetooth profile (maybe others as well), 
that is not plain IEEE 802.15.1.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
