Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbZFBIaM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 2 Jun 2009 04:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbZFBI34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:29:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:41587 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370AbZFBI3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M2F9XoVSnBBtjXJvU2TMULjS25wJ6kOpPDDdUSSHeVA0DtTw9vWOalWUiu95MORUjY
         U6zehcfVEShf/RO/4qs3qLBithMjZAfGkGYeXZZ59kPTWRIWoulbdbdwFyNSBMpZ96sh
         PVUyHusgMp21TDJDqO12Gu22Cwm1oealzzpvE=
MIME-Version: 1.0
In-Reply-To: <1243930893.3192.62.camel@localhost.localdomain>
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	 <69e28c910906010921r56cf7017gc858cb7ba819c385@mail.gmail.com>
	 <20090601203348.GC7143@doriath.ww600.siemens.net>
	 <200906021010.49613.hs4233@mail.mn-solutions.de>
	 <1243930893.3192.62.camel@localhost.localdomain>
Date: Tue, 2 Jun 2009 12:29:55 +0400
Message-ID: <bc64b4640906020129x4fe15e5en9d8e2cad1d86b236@mail.gmail.com>
Subject: =?KOI8-R?B?79TXxdQ6IFtQQVRDSCAxMC8xMF0gaWVlZTgwMjE1NDogYWRkIGF0ODZyZjIzMC8=?=
	=?KOI8-R?B?cmYyMzEgc3BpIGRyaXZlcg==?=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
   linux-wireless@vger.kernel.org,
   =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
   linux-kernel@vger.kernel.org, netdev@vger.kernel.org, slapin@ossfans.org,
   maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
   oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/2, Marcel Holtmann <marcel@holtmann.org>:
> Hi Holger,
>
>> > I thought about drivers/net as about ip (well, more or less)
>> > network drivers. We have drivers/atm or drivers/bluetooth (and
>> > bluetooth is 802.15.1...).
>>
>> I actually like that this is drivers/bluetooth and not
>> drivers/ieee802151. Would you consider drivers/zigbee instead of
>> drivers/ieee802154 ???
>
> I fully agree here.
>
> Please use "zigbee" instead of "ieee*" names since that can become messy
> and confusing. I know that in theory the IEEE part of ZigBee is more
> low-level radio and could be used by non-ZigBee devices, but that is not
> gonna happen anyway. Especially with Bluetooth Low Energy pushing into
> the turf of ZigBee. So please use proper names and not confuse people
> with IEEE numbers ;)

This gonna happen, as we are most probably going to implement 6lowpan
on top of our stack. 6lowpan is a way to encapsulate IPv6 frames into
IEEE 802.15.4 and has nothing in common with ZigBee. Moreover
ZigBee is a trademark with strict rules upon it's usage. Our lawyers are
currently investigating if it's possible to use this name in projects like
Linux kernel which are open-source, non-related to any project but
OTOH can be encapsulated in any commercial project.

IEEE 802.15.4 is a term like IEEE 802.11. We do have mac80211,
we have had (until recently) ieee80211 dir, so why bother?

For Bluetooth naming directories 'bluetooth' is logical, as 802.15.1
standard is a less known name, doesn't incorporate latest changes
from Bluetooth, etc.

-- 
With best wishes
Dmitry
