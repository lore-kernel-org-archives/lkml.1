Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbXJKPFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbXJKPFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXJKPEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:04:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42067 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbXJKPEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:04:50 -0400
Message-ID: <470E3B8D.4080002@garzik.org>
Date: Thu, 11 Oct 2007 11:04:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bernd Schubert <bs@q-leap.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] faster workaround
References: <200710081709.18253.bs@q-leap.de> <20071011142628.48272a4a@the-village.bc.nu> <470E30F9.5060705@garzik.org> <200710111639.38240.bs@q-leap.de>
In-Reply-To: <200710111639.38240.bs@q-leap.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert wrote:
> On Thursday 11 October 2007 16:19:37 Jeff Garzik wrote:
>> 1) Just about the only valid optimization is to ensure that only the
>> write path must be limited to small chunks, not both read- and
>> write-paths.  Tejun had a patch to do this a long time ago, but it's an
>> open question whether the large amount of code is worth it for a rare
>> combination.
> 
> How large? This patch is rather small? Where can I find it?

http://home-tj.org/wiki/index.php/Sil_m15w

> The problem came up, when 200GB drives were replaced by *newer* 250GB drives 
> (well maybe not the newest, no idea were they came from).
> 
> Anyway, I'm testing for more than 24h already and didn't observe any data 
> corruption as without the patch. I know this is only an obersavation and no 
> definite prove...
> Also, this is with 3114, maybe this chip behaves a bit different than 3112?

3114 + new SATA drive is definitely a new one for us.

It would help to (a) use the latest kernel, (b) post your .config with 
the latest kernel, (c) post lspci booted into latest kernel, and (d) 
post dmesg booted into latest kernel.

	Jeff


