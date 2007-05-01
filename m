Return-Path: <linux-kernel-owner+w=401wt.eu-S1031227AbXEANYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031227AbXEANYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031219AbXEANYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:24:47 -0400
Received: from rtr.ca ([64.26.128.89]:2290 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192AbXEANYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:24:45 -0400
Message-ID: <46373F9A.9020705@rtr.ca>
Date: Tue, 01 May 2007 09:24:42 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: William Thompson <wt@electro-mechanical.com>
Cc: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: 2.6.20 libata cdrom
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com>
In-Reply-To: <20070501131818.GA18521@electro-mechanical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Thompson wrote:
>
> The one thing I do know, the machine with the non-working libata cdrom also
> does not work with the ide driver *ONLY IF* DMA is turned on.

That's probably because it's a mdma2 device, and not many chipsets seem
to do mdma2 correctly.  I had a drive like that around here, too.
It could do dma on only one motherboard out of our half dozen or so.

But libata might actually be able to use mdma2 with it,
as I believe (unsubstantiated) that Alan may have done
a better implementation of setting the timings than what
we had with our old IDE drivers.

Cheers
