Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZFPKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZFPKBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFPKBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:01:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:8514 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZFPKBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=B1yiuiTY74ONpBBIVKq/vw1Gb3BKkXxi0ztOLD/aBY8EebisTTdlW+fK2tb6v1gaAH
         9RfSmeLvtW4/fxWuUAnHM8qAy7C+vAIBmX51MFP9SKqgYv43SF5Hh1UckMq9Ew0r2ORA
         sTEFZUnoxlN/zTGScZ92CI8klCvYLxBcB+4Vk=
MIME-Version: 1.0
In-Reply-To: <200906151337.17066.arnd@arndb.de>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> 
	<1244980878-2124-11-git-send-email-vapier@gentoo.org> <200906151337.17066.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 16 Jun 2009 06:00:50 -0400
Message-ID: <8bd0f97a0906160300s15982889h11487a8421f95582@mail.gmail.com>
Subject: Re: [PATCH 10/17] Blackfin: convert dma/pci to asm-generic
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 07:37, Arnd Bergmann wrote:
> On Sunday 14 June 2009, Mike Frysinger wrote:
>> --- a/arch/blackfin/include/asm/dma-mapping.h
>> +++ b/arch/blackfin/include/asm/dma-mapping.h
>> @@ -2,97 +2,28 @@
>>  #define _BLACKFIN_DMA_MAPPING_H
>>
>>  #include <asm/scatterlist.h>
>> +#include <asm-generic/dma-mapping-broken.h>
>
> I would leave this one alone, I don't think that moving
> to dma-mapping-broken.h helps here.

just trying to punt as much as possible from arch/blackfin/ as it
means less stuff for me to worry about :).  i'll drop the
dma-mapping.h change from this patch.

> I have a dma-mapping
> branch in my asm-generic repository. While I could not
> get an agreement on an approach for a common dma-mapping.h
> file for asm-generic, I did a number of cleanups on a few
> architectures. Feel free to take this patch as a base for
> your work.

once i get most of my local queue settled, i'll look at integrating
this.  thanks!
-mike
