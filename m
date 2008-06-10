Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYFJJz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYFJJz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYFJJzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:55:11 -0400
Received: from mail.atmel.fr ([81.80.104.162]:36854 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYFJJzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:55:09 -0400
Message-ID: <484E4F61.7010007@atmel.com>
Date: Tue, 10 Jun 2008 11:54:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Marc Pignat <marc.pignat@hevs.ch>, Eric BENARD <ebenard@free.fr>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       =?ISO-8859-1?Q?Hans-J=FCrgen_?= =?ISO-8859-1?Q?Koch?= 
	<hjk@linutronix.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4?= =?ISO-8859-1?Q?l=E4?= 
	<syrjala@sci.fi>
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
References: <483FE9E7.7020707@atmel.com> <20080609124623.5b6bda48@mjolnir.drzeus.cx>
In-Reply-To: <20080609124623.5b6bda48@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Fri, 30 May 2008 13:49:59 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Hi Pierre,
>>
>> Following your announce of future removal of the MMC multiwrite switch 
>> and the contributions of several people of the AT91 community, here is a 
>> patches series :
>> Those patches should enhance transfer of data and setup a sane base for 
>> a working SDIO support.
>>
> 
> I have no big concerns about the patches.

Ok, good !

> There were some comments from
> other people though. Do you want to have a look at those first?

Russell King highlights that patch #4 is not well inserted in the series 
: it have to be after #5 (after correcting bytes_xfered update).

If you want I can reorder them... or you manage to do it.

I will take into account Marc's comment and new Ville patch series in 
another round ;-)

Btw, you can also add the "manage cmd error and data error 
independently" patch I have just sent.

Kind regards,
-- 
Nicolas Ferre

