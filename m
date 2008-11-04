Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYKDS4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYKDS4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbYKDS4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:56:17 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:48239 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754730AbYKDS4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:56:16 -0500
Message-ID: <49109AC9.5090406@ru.mvista.com>
Date: Tue, 04 Nov 2008 21:56:09 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] rz1000: apply chipset quirks early
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain> <20081103200306.5098.41565.sendpatchset@localhost.localdomain> <491083E9.60305@ru.mvista.com>
In-Reply-To: <491083E9.60305@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> Index: b/drivers/ide/rz1000.c
>> ===================================================================
>> --- a/drivers/ide/rz1000.c
>> +++ b/drivers/ide/rz1000.c
>> @@ -22,34 +22,48 @@
>>  
>>  #define DRV_NAME "rz1000"
>>  
>> -static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
>> +static unsigned int __devinit rz1000_init_chipset(struct pci_dev *dev)

>    Hm, this is not a real init_chipset() method and it does just one 
> thing -- disables readahead, so rz1000_disable_readahead() or something 
> of that sort seems like a better name...

    Hm, 'unsigned' result type wasn't terribly helpful here as well. :-)

MBR, Sergei
