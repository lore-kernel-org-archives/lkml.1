Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYAIDa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYAIDa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYAIDaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:30:13 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:27412 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYAIDaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:30:11 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 22:30:11 EST
X-IronPort-AV: E=Sophos;i="4.24,260,1196658000"; 
   d="scan'208";a="46426565"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] split MMC_CAP_4_BIT_DATA
Date: Wed, 9 Jan 2008 11:21:40 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
In-Reply-To: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] split MMC_CAP_4_BIT_DATA
Thread-Index: AchSZ+6XIxawlxXpT16EulmuksOd2wAAoKwA
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jan 2008 03:20:26.0930 (UTC) FILETIME=[9460A120:01C8526E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi,all

I'd like to say something about this issue.
Currently,the blackfin on chip SD host ONLY support 1-bit MMC while
support 1-bit/4-bit SD/SDIO.
And we want our driver to support both 1-bit MMC and 4-bit SD/SDIO.but
the current MMC driver framework
Only allow us to set one kind of bus width,either 1-bit or 4-bit.So in
order to meet our case,we need more flexible mechanism
To inform the upper commom driver to know our situation.

Cliff

 

-----Original Message-----
From: Bryan Wu [mailto:cooloney.lkml@gmail.com] 
Sent: Wednesday, January 09, 2008 10:33 AM
To: Pierre Ossman; cliff.cai@analog.com
Cc: Mike Frysinger; linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA

On Jan 9, 2008 4:49 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Tue, 8 Jan 2008 14:40:49 -0500
> Mike Frysinger <vapier.adi@gmail.com> wrote:
>
> >
> > i dont understand what's confusing.  the Blackfin on chip host 
> > controller only supports 1-bit MMC, but it supports 4-bit SD/SDIO.  
> > this is a fact.  while it may be a stupid decision, it is what it 
> > is, and i need the framework made more flexible in order to get the 
> > Blackfin driver merged cleanly.  we do software for hardware, we
dont do hardware.
>
> Well, since I've seen no _hardware_ differences between 4-bit MMC and
4-bit SD, "support" in this case must me "vendor will guarantee it
works". And that is not the kind of "support" that needs a distinction
in the code.
>
> So, again, if you feel that there is a hardware difference between
4-bit MMC and 4-bit SD then please elaborate as it is my understanding
that they are identical.
>

As Mike said, the reason split this flag is because Blackfin on-chip
SDIO controller's limitation.
Cliff is working on it for a long time, so I dropped him in. Hope he can
clarify the confusing things.

Thanks
-Bryan Wu
