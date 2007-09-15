Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbXIOJBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbXIOJBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXIOJBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:01:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59036 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbXIOJBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:01:32 -0400
Date: Sat, 15 Sep 2007 11:01:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kees Cook <kees@ubuntu.com>, linux-kernel@vger.kernel.org,
       Ben Collins <bcollins@ubuntu.com>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
In-Reply-To: <46E8DBE3.7040204@garzik.org>
Message-ID: <Pine.LNX.4.64.0709151101170.13411@fbirervta.pbzchgretzou.qr>
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org>
  <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com> 
 <20070912215356.GC23294@kroah.com>  <20070912160827.e359a53b.akpm@linux-foundation.org>
 <b6fcc0a0709122334qa31fffby4afbf857c92efb89@mail.gmail.com>
 <46E8DBE3.7040204@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 13 2007 02:42, Jeff Garzik wrote:
> Alexey Dobriyan wrote:
>> -static struct pci_device_id rtl8139_pci_tbl[] = {
>> +PCI_MODULE_DEVICE_TABLE_BEGIN(rtl8139_pci_tbl)
>>   {0x10ec, 0x8139, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
>>   {0x10ec, 0x8138, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
>>   {0x1113, 0x1211, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
>> @@ -273,10 +273,7 @@ static struct pci_device_id rtl8139_pci_tbl[] = {
>>   {PCI_ANY_ID, 0x8139, 0x10ec, 0x8139, 0, 0, RTL8139 },
>>   {PCI_ANY_ID, 0x8139, 0x1186, 0x1300, 0, 0, RTL8139 },
>>   {PCI_ANY_ID, 0x8139, 0x13d1, 0xab06, 0, 0, RTL8139 },
>> -
>> -	{0,}
>> -};
>> -MODULE_DEVICE_TABLE (pci, rtl8139_pci_tbl);
>> +PCI_MODULE_DEVICE_TABLE_END

That looks sooo... wxwidgets-like :)

> I think the previous version looks better.

Nod.



