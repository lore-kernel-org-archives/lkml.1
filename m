Return-Path: <linux-kernel-owner+w=401wt.eu-S932807AbXBQT00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbXBQT00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 14:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXBQT00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 14:26:26 -0500
Received: from h155.mvista.com ([63.81.120.155]:58451 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932807AbXBQT0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 14:26:25 -0500
Message-ID: <45D756D7.4060106@ru.mvista.com>
Date: Sat, 17 Feb 2007 22:26:15 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, Jeff Garzik <jgarzik@pobox.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.20-rc4-mm1: PCI=n: drivers/net/3c59x.c compile error
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070124135354.GI17836@stusta.de> <45B76946.1070009@ru.mvista.com>
In-Reply-To: <45B76946.1070009@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:
>> 3x59x-fix-pci-resource-management.patch causes the following compile 
>> error with CONFIG_PCI=n:

>> <--  snip  -->

>> ...
>>   CC      drivers/net/3c59x.o
>> /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c: 
>> In function 'vortex_init_one':
>> /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c:961: 
>> error: implicit declaration of function 'pci_request_regions'
>> /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/net/3c59x.c:985: 
>> error: implicit declaration of function 'pci_release_regions'
>> make[3]: *** [drivers/net/3c59x.o] Error 1

>    Grr, at at the same time it's happy with pci_enable_device().
>    I'd say the problem is in <linux/pci.h>,  not in the patch.

    Has there been any patch to fix the "unbalanced" 
pci_{request|release}_regions() declarations? Am I suposed to create such?

>> cu
>> Adrian

MBR, Sergei


