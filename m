Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYA3Kiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYA3Kiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbYA3Kin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:38:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58671 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbYA3Kil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:38:41 -0500
Message-ID: <47A053AE.7050900@garzik.org>
Date: Wed, 30 Jan 2008 05:38:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
References: <20080130094440.GA4652@havoc.gtf.org> <20080130102116.GA20846@uranus.ravnborg.org>
In-Reply-To: <20080130102116.GA20846@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> Jeff Garzik (1):
>>       [netdrvr] sis190: build fix
> 
> But you did it wrong...
> sis190.c b/drivers/net/sis190.c
>> index b570402..2e9e88b 100644
>> --- a/drivers/net/sis190.c
>> +++ b/drivers/net/sis190.c
>> @@ -326,7 +326,7 @@ static const struct {
>>  	{ "SiS 191 PCI Gigabit Ethernet adapter" },
>>  };
>>  
>> -static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
>> +static struct pci_device_id sis190_pci_tbl[] = {
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
>>  	{ 0, },
> 
> The __devinitdata is OK, it is the following _devinitdata that had to be _devinitconst.

Cool.  Either way is fine with me.  I just wanted to get a build fix 
upstream ASAP, one I was sure would work.

	Jeff



