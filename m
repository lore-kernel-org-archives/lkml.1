Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbZEOFaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbZEOFaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZEOFaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:30:06 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:51795 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZEOFaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=yEn6TIJUYqrNP/0wKwlChXyfgXbmA/GOnScwOePzirNu00IxqCdFhhUT5/ktJdR5+u
         SSyOj6L4myAeXLqg5IO/Oc1tNqSN5qghUJx0LSH+e9oYrWfDnowZtUqQYHb7slKoN/Bu
         x7yBZzgow+WRRYziAQkw2szktt4D/6GgcZ3NQ=
Message-ID: <4A0CFE1F.5080409@gmail.com>
Date: Fri, 15 May 2009 14:31:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: hancockrwd@gmail.com, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, arnd@arndb.de,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
References: <20090513043409.GA13577@cynthia.pants.nu>	<20090513095127.308b00e7@lxorguk.ukuu.org.uk>	<4A0B5E5A.4090906@gmail.com> <20090514091928R.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090514091928R.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 13 May 2009 17:57:14 -0600
> Robert Hancock <hancockrwd@gmail.com> wrote:
> 
>> Alan Cox wrote:
>>>>> If it doesn't interfere with plain PIO mode, fine. 
>>>> I agree. There definitely needs to still be support for IDE ports that
>>>> don't have DMA capability.
>>> There is - it's just if the platform doesn't implement the dma_* APIs you
>>> get a problem.
>> Wouldn't the easiest solution be to just dummy out the DMA API calls on 
>> this platform to always fail? That would fix these compile problems..
> 
> Can libata call dma_supported() per device to decide DMA or PIO mode?
> Then, we can solve this problem by add dummy DMA API (just calls BUG)
> on such architectures, without Kconfig magic or adding ifdef (like the
> old ide stack does), I think.

Sure it can.  Which specific drivers are we talking about?

Thanks.

-- 
tejun
