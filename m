Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXGFTG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXGFTG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbXGFTGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:06:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:53285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbXGFTGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:06:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,509,1175497200"; 
   d="scan'208";a="103648303"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel Santa Rosa PATA controller
Date: Fri, 6 Jul 2007 12:06:44 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE070181E0EA@orsmsx420.amr.corp.intel.com>
In-reply-to: <200707052230.25310.chunkeey@web.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel Santa Rosa PATA controller
Thread-Index: Ace/QzJPNxOzHlgiRF2ZOJznRpbW9AAvRLRQ
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: <chunkeey@web.de>, "Thorsten Leemhuis" <thl@ct.heise.de>
Cc: "Thorsten Leemhuis" <fedora@leemhuis.info>,
       "Chuck Ebbert" <cebbert@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Jul 2007 19:06:45.0062 (UTC) FILETIME=[CB88C660:01C7C000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: chunkeey@web.de [mailto:chunkeey@web.de] 
>Sent: Thursday, July 05, 2007 1:30 PM
>To: Thorsten Leemhuis
>Cc: Thorsten Leemhuis; Chuck Ebbert; Jeff Garzik; IDE/ATA 
>development list; Gaston, Jason D; Alan Cox; 
>linux-kernel@vger.kernel.org; chunkeey@web.de
>Subject: Re: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel 
>Santa Rosa PATA controller
>
>On Wednesday, 4. July 2007, Thorsten Leemhuis wrote:
>>
>> Maybe Alan or someone from Intel can answer that and thus 
>tell us how to
>> move forward; it would be really nice to get the patch that 
>started this
>> thread (it got posted by Chuck again today) could go into 
>2.6.22, but I
>> assume the time runs away...
>>
>Jeff is on holiday and Intel doesn't respond at all... 
>
>So, if someone has a ICH5 or ICH7/7-R with a ATA133 captable 
>HDD... could
>you please try the following patch? (Of course, I don't know 
>if it works,...
>It may cause data loss, serve corruption, or damage your 
>controller/hdd/pc,
>so make backups and keep a first-aid kit handy!) 
>  
>> > On the other hand, we can leave it, because of a 
>"off-by-one error" in ata_piix.c, 
>> > do_pata_set_dmamode, line ~770:
>> > [...]
>> 
>
>Thanks,
>	Chr.
>
>

I quickly tried this patch on an ICH7-R system with an ATA133 Maxtor HD
and it did not seem to do anything bad.  I see no difference in function
or performance with the patch.

Jason
