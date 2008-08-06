Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYHFNFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYHFNFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYHFNFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:05:07 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:14134 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYHFNFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=e+sczc9AvkHsgX2vMzm0SSQMbIsB7kauWQ/N3IT8SkFln0igU05nn1VGHpeoesL3/I
         u4a8IqhJ1Fd4yoSawI0Tj19On1rVAT5q03rfEnlf1En+E2/b2vdbG1YpuDsZ7SgjmYky
         LaqYQFLY20nkVJQi+zp5JXZTQFRCArWAdepNg=
Message-ID: <4899A15B.8000800@gmail.com>
Date: Wed, 06 Aug 2008 22:04:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-ide <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit request for Discussion of
 future of ATA (libata) and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no>	<fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no>	<fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>	<48976168.3020804@shaw.ca>	<20080804205508.20a3f917@lxorguk.ukuu.org.uk>	<48977200.3050307@shaw.ca>	<20080804220619.76b94ceb@lxorguk.ukuu.org.uk>	<4898EE70.1030604@shaw.ca> <4898F3EA.7000507@gmail.com> <48998A8B.9040109@ru.mvista.com>
In-Reply-To: <48998A8B.9040109@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Tejun Heo wrote:
>>> +unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
>>> +			       unsigned int buflen, int rw)
>>> +{
>>> +	struct ata_port *ap = dev->link->ap;
>>> +	void __iomem *data_addr = ap->ioaddr.data_addr;
>>> +	unsigned int words = buflen >> 2;
>>>     
>> dwords maybe?
>>   
> 
>    Isn't word 32-bit in the 32-bit systems? We're not on 80[12]86 
> (despite Intel/MS preference of calling 32-bit memory cells DWORDS)...

Well, as most of machines are 64-bit these days, discussing whether a
word means 16 or 32 bits is kind of moot.  I usually just think byte,
word, dword, qword and and libata and pci assume that too -
ata_id_has_dword_io() and PCI configuration accessors.  It's ultimately
a peripheral issue either way tho.

Thanks.

-- 
tejun
