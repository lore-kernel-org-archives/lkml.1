Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349Ab0AJTn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0AJTn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 14:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153Ab0AJTn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 14:43:56 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:60345 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0AJTn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 14:43:56 -0500
Message-ID: <4B4A2DF7.5020907@freemail.hu>
Date: Sun, 10 Jan 2010 20:43:51 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: Re: [PATCH 3/3] serial: make PCI device id constant
References: <4B4A077C.7020406@freemail.hu> <e2d7436a1001100951w4dd7139as96e5808872f5c926@mail.gmail.com>
In-Reply-To: <e2d7436a1001100951w4dd7139as96e5808872f5c926@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha³ Miros³aw wrote:
> 2010/1/10 Németh Márton <nm127@freemail.hu>:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> The id_table field of the struct pci_driver is constant in <linux/pci.h>
>> so it is worth to make initialization data also constant.
> [...]
>> diff -u -p a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
>> --- a/drivers/serial/8250_pci.c 2009-12-03 04:51:21.000000000 +0100
>> +++ b/drivers/serial/8250_pci.c 2010-01-08 18:40:05.000000000 +0100
>> @@ -2567,7 +2567,7 @@ static int pciserial_resume_one(struct p
>>  }
>>  #endif
>>
>> -static struct pci_device_id serial_pci_tbl[] = {
>> +static const struct pci_device_id serial_pci_tbl[] = {
>>        /* Advantech use PCI_DEVICE_ID_ADVANTECH_PCI3620 (0x3620) as 'PCI_SUBVENDOR_ID' */
>>        {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
>>                PCI_DEVICE_ID_ADVANTECH_PCI3620, 0x0001, 0, 0,
> [...]
> 
> There was similar patch sent to netdev couple days ago. For PCI
> devices it used DEFINE_PCI_DEVICE_TABLE() like this:
> 
> static DEFINE_PCI_DEVICE_TABLE(serial_pci_tbl) = {
> 
> so that the ID data went to the proper .ko section.

Thanks for the feedback. The DEFINE_PCI_DEVICE_TABLE() is also recommended
by Documentation/PCI/pci.txt .

Regads,

	Márton Németh
