Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbXEJOBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbXEJOBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761499AbXEJN7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:59:15 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47227 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760846AbXEJN7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:59:13 -0400
Message-ID: <46432502.4050901@drzeus.cx>
Date: Thu, 10 May 2007 15:58:26 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx> <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx>
In-Reply-To: <4642B122.5070609@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

You seem to be the source of this workaround, and also the maintainer of
PXA. So I guess this falls into your lap either way. Highlights from my
discussion with Russell:

Pierre Ossman wrote:
> Russell King wrote:
>   
>> > Dug out from the ARM kautobuild...
>> >
>> > drivers/mmc/host/pxamci.c: In function 'pxamci_cmd_done':
>> > drivers/mmc/host/pxamci.c:236: error: 'MMC_ALL_SEND_CID' undeclared (first use in this function)
>> > drivers/mmc/host/pxamci.c:236: error: (Each undeclared identifier is reported only once
>> > drivers/mmc/host/pxamci.c:236: error: for each function it appears in.)
>> > drivers/mmc/host/pxamci.c:237: error: 'MMC_SEND_CSD' undeclared (first use in this function)
>> > drivers/mmc/host/pxamci.c:238: error: 'MMC_SEND_CID' undeclared (first use in this function)
>> >
>> >   
>>     
>
> What are opcode defines doing in the driver?

Pierre Ossman wrote:
> Russell King wrote:
>   
>> See the comments immediately above and below its use.
>>
>> Welcome to buggy hardware.
>>
>>   
>>     
>
> I've read through the erratum, and to me it seems like the bug affects
> all long replies, not just these codes. So I think the code should be
> fixed to look at the response flag, not the opcode.
>
> Do you have hardware so that you can test such a change?
>
>   

I guess the same question goes to you. :)

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

