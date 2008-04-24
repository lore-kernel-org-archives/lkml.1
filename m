Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYDXMqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYDXMqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYDXMqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:46:10 -0400
Received: from homer.mvista.com ([63.81.120.155]:63950 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752810AbYDXMqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:46:08 -0400
Message-ID: <481080EA.7010107@ru.mvista.com>
Date: Thu, 24 Apr 2008 16:45:30 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>	<480DE3C4.5@ru.mvista.com>	<480DE6F5.8060403@gmail.com>	<480DE9E8.2070809@ru.mvista.com>	<480DEB1F.5060500@gmail.com> <20080424123541.09e5ef96@the-village.bc.nu>
In-Reply-To: <20080424123541.09e5ef96@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>Sergei Shtylyov wrote:

>>>>>   Jeff, Tejun, what "sff" in the file name actually means? Isn't it 
>>>>>strange that the drivers lacking DMA support or not really compliant 
>>>>>with SFF-8038i have to link with this file?

>>>>Maybe it should be libata-tf and libata-bmdma, but sff (sans bmdma)
>>>>and bmdma is acceptable, hopefully, right?

>>>   What's sff sans bmdma?

>>Supposed to be TF interface.  IIRC, the SFF term was first from Alan 
>>although it's entirely possible that I misunderstood it and used it in 
>>the wrong way.  Alan, can you please clear up the confusion?

> The SFF/Intel spec is for PCI IDE (BMDMA or otherwise), so it covers and
> defines all the common bits of the IDE interface on PCI (and in defining
> the legacy interface conveniently documents the extended ST-412 interface
> used by ATA and "pre-ATA" IDE/EIDE controllers).

    If you mean SFF-8038i (which can indeed be named "SFF/Intel"), it
documents *only* BMDMA.  If you mean something else, please be more precise.

> Alan

WBR, Sergei

