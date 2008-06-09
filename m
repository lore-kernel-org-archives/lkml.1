Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbYFIURV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbYFIURV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYFIURN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:17:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:56122 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYFIURN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n2WJN06ujnrKfICtVfFuRIyOzBOSp8rCFPjKiakqE2eIbgtt7gg7UjYjAxYT2AFjkX
         Fmgerv7doHZ4sYes3mB5e6jodEe8fqE8vNymTu6EbvHwYvBe4WUuowA7LMl4mRDweZz/
         p0vFEAIdqvPnfmiNRDiZW+zIxpKknPRNjflcU=
Message-ID: <cd73a99e0806091317q37d134acu8b7d4033e769fcc1@mail.gmail.com>
Date: Mon, 9 Jun 2008 22:17:12 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Richard Genoud" <richard.genoud@gmail.com>
Subject: Re: [PATCH 4/8] atmel_nand: Clean up and fix probe() error path
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Patrice VILCHEZ" <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <80b317760806090004v56436872oac76944e39f57860@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
	 <cd73a99e0806070908n5c9b6be4ned0386905555a1b7@mail.gmail.com>
	 <20080607191815.3dc24360@siona.local>
	 <80b317760806090004v56436872oac76944e39f57860@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

>> Then the driver can do
>>        if (host->board->ecc_regs)
>>                host->ecc = host->board->ecc_regs;
>>        else if (regs)
>>                host->ecc = ioremap(regs->start, regs->end - regs->start + 1);
>>
>>        if (hard_ecc && !host->ecc)
>>                printk("Hardware ECC not available\n");
>>
>> Right? I think we use a similar trick in the atmel_serial driver too.
>
> It may be the best solution indeed.

Agreed.


Regards,
  Andrew Victor
