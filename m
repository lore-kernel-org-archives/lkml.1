Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbYBVKO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbYBVKO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYBVKOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:14:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46278 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYBVKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:14:18 -0500
Message-ID: <47BEA0DF.9070800@firstfloor.org>
Date: Fri, 22 Feb 2008 11:15:59 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org>	<47B2DBA5.6030001@goop.org>	<20080214022744.GA4160@mail.oracle.com>	<47B3F2DC.8080707@goop.org>	<20080215202336.GE26034@mail.oracle.com>	<1203274161.27987.6.camel@localhost.localdomain>	<20080218104025.GA15899@ca-server1.us.oracle.com>	<1203458366.26910.15.camel@cthulhu.hellion.org.uk>	<47BBDA20.8030105@zytor.com>	<1203497511.26910.39.camel@cthulhu.hellion.org.uk>	<47BCA275.7000504@goop.org>	<1203546597.26910.74.camel@cthulhu.hellion.org.uk>	<47BDEA11.6010302@goop.org>	<47BDEB57.5040203@zytor.com>	<47BDEF36.8000903@goop.org>	<1203631956.28436.4.camel@cthulhu.hellion.org.uk>	<47BDF9C7.6040400@zytor.com>	<47BE0017.1020205@goop.org>	<47BE0228.7020204@zytor.com>	<1203665106.28436.19.camel@cthulhu.hellion.org.uk>	<20080222092855.6ace8845@core>	<47BE9C18.5060202@firstfloor.org> <20080222100034.1e78d661@core>
In-Reply-To: <20080222100034.1e78d661@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Actually I switched 64bit over to trust e820 completely and not
>> reserve 640k-1MB explicitly some time ago
>> and AFAIK there hasn't been any reports that it causes problems.
>>
>> So presumably trusting e802 is ok on modern systems (2003+)
> 
> Apparently so - at least 64bit capable ones. 

They should all use the same BIOS code bases, except perhaps
some embedded weirdnesses.

We do still sort the entries
> to remove zero length records and other suprises.

That code could be actually dropped. And the sorting too.
It's all not needed I think.

AFAIK none of the e820 access code cares about any of
that.

64bit only has it because I copied it originally and never
bothered to remove it.

-Andi

