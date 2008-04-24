Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYDXMu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYDXMu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYDXMuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:50:18 -0400
Received: from rtr.ca ([76.10.145.34]:3542 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYDXMuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:50:16 -0400
Message-ID: <48108208.8060302@rtr.ca>
Date: Thu, 24 Apr 2008 08:50:16 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>	<480DE3C4.5@ru.mvista.com>	<480DE6F5.8060403@gmail.com>	<480DE9E8.2070809@ru.mvista.com>	<480DEB1F.5060500@gmail.com> <20080424123541.09e5ef96@the-village.bc.nu> <481080EA.7010107@ru.mvista.com>
In-Reply-To: <481080EA.7010107@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Alan Cox wrote:
> 
>>> Sergei Shtylyov wrote:
> 
>>>>>>   Jeff, Tejun, what "sff" in the file name actually means? Isn't 
>>>>>> it strange that the drivers lacking DMA support or not really 
>>>>>> compliant with SFF-8038i have to link with this file?
> 
>>>>> Maybe it should be libata-tf and libata-bmdma, but sff (sans bmdma)
>>>>> and bmdma is acceptable, hopefully, right?
> 
>>>>   What's sff sans bmdma?
> 
>>> Supposed to be TF interface.  IIRC, the SFF term was first from Alan 
>>> although it's entirely possible that I misunderstood it and used it 
>>> in the wrong way.  Alan, can you please clear up the confusion?
> 
>> The SFF/Intel spec is for PCI IDE (BMDMA or otherwise), so it covers and
>> defines all the common bits of the IDE interface on PCI (and in defining
>> the legacy interface conveniently documents the extended ST-412 interface
>> used by ATA and "pre-ATA" IDE/EIDE controllers).
> 
>    If you mean SFF-8038i (which can indeed be named "SFF/Intel"), it
> documents *only* BMDMA.  If you mean something else, please be more 
> precise.
..

The "Intel PCI IDE Controller Specification Revision 1.0 3/4/94" doesn't mention
bmdma at all, but does document the taskfile register addresses.
It defers to ATA-1 for actual taskfile descriptions/functionality, though.

There's nothing particularly bad about the current naming we use, though.

Cheers
