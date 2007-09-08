Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbXIHGlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbXIHGlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 02:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbXIHGlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 02:41:01 -0400
Received: from mi1.bluebottle.com ([206.188.25.14]:34208 "EHLO
	mi1.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXIHGlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 02:41:00 -0400
DomainKey-Signature: a=rsa-sha1; s=mail; d=bluebottle.com; c=nofws; q=dns;
	h=received:from:to:cc:references:subject:date:mime-version:
	content-type:content-transfer-encoding:x-priority:
	x-msmail-priority:x-mailer:x-mimeole:x-trusted-delivery;
	b=IAqSpiPmOwQo/aR62HWixiPQ2WCmcO8rZmvE7+itwtdTWHkBuwnW8MGQ0K8ocBedx
	jryVXupde04W8S4k+BxeQg0h+/ZTWWc6KNlIHxPF1vUVEad8XAZe2MnzfiA7N8E
Message-Id: <200709080640.l886exPi003724@mi1.bluebottle.com>
From: "n" <xellos@bluebottle.com>
To: "Jeff Garzik" <jeff@garzik.org>, "David Chinner" <dgc@sgi.com>
Cc: <linux-kernel@vger.kernel.org>
References: <007d01c7eaf6$74b9b350$0100a8c0@hak> <20070907130212.GI995458@sgi.com> <46E1E2F6.5060307@garzik.org>
Subject: Re: limiting to UDMA/33 instead of UDMA/100 - pata_pdc202xx_old (also XFS error)?
Date: Fri, 7 Sep 2007 23:41:10 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Trusted-Delivery: <3595b99efde2489f3a1ea5efc6fe0bea>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i doubt its bad harddrive / powersupply (just replaced it) , i think this
new driver has some bugs that need to be fixed, if i use the old ide
pdc202xx_old the drive works fine maybe the new driver is detecting res
51/84:00:3f:00:00/00:00:00:00:00/e0 as ata bus error when it might be
seagates way of saying OK or success (im not sure), anyways for the time
being im running the old ide drivers on the promise ide card untill the new
drivers get some more bugs fixed, im using the new nforce2 ata drivers
flawlessly for the system drives, the pdc card is just for backups..

maybe when the next kernel comes out ill try the new pata_pdc202xx_old
drivers again.


----- Original Message ----- 
From: "Jeff Garzik" <jeff@garzik.org>
To: "David Chinner" <dgc@sgi.com>; "n" <xellos@bluebottle.com>
Cc: <linux-kernel@vger.kernel.org>
Sent: Friday, September 07, 2007 4:47 PM
Subject: Re: limiting to UDMA/33 instead of UDMA/100 - pata_pdc202xx_old
(also XFS error)?


>>>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus
>>> error)
>>>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus
>>> error)
>>>         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus
>>> error)
>
>
> ATA bus error == straight-from-hardware reported error
>
> Cable or connector is dying maybe?  Bad power supplies also sometimes
> manifest this way.
>
> Jeff
>
>

----------------------------------------------------------------------
Get a free email account with anti spam protection.
http://www.bluebottle.com/tag/2

