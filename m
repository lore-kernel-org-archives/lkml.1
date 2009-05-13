Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbZEMX5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbZEMX5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZEMX5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:57:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:52526 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZEMX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XJImVJ4B3FNsxUYOJ9hwdGJFeTDpid2jmmTaOdnAuqhBYKW999KWxC3/WrrFIlDtGf
         cE3a1u8mjaXWO7365eXvPlZqCErCPeLde7bTUA/WxtubIe+K90m8wO+WkfPoPVYYKdOg
         ht5ksRUu7ybLfvCrC9Nb/vBsbnq4/sZDx5kc0=
Message-ID: <4A0B5E5A.4090906@gmail.com>
Date: Wed, 13 May 2009 17:57:14 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Brad Boyer <flar@allandria.com>,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
References: <20090511222702.352192505@arndb.de>	<200905112238.55404.arnd@arndb.de>	<20090512090602.65722342@lxorguk.ukuu.org.uk>	<200905121123.21436.arnd@arndb.de>	<20090513033027.GA13193@cynthia.pants.nu>	<alpine.DEB.1.00.0905130610240.18305@zirkon.biophys.uni-duesseldorf.de>	<20090513043409.GA13577@cynthia.pants.nu> <20090513095127.308b00e7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090513095127.308b00e7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> If it doesn't interfere with plain PIO mode, fine. 
>> I agree. There definitely needs to still be support for IDE ports that
>> don't have DMA capability.
> 
> There is - it's just if the platform doesn't implement the dma_* APIs you
> get a problem.

Wouldn't the easiest solution be to just dummy out the DMA API calls on 
this platform to always fail? That would fix these compile problems..
