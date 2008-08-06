Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbYHFL1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbYHFL1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbYHFL1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:27:17 -0400
Received: from h155.mvista.com ([63.81.120.155]:40034 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758440AbYHFL1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:27:16 -0400
Message-ID: <48998A8B.9040109@ru.mvista.com>
Date: Wed, 06 Aug 2008 15:27:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no> <fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no> <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no> <48976168.3020804@shaw.ca> <20080804205508.20a3f917@lxorguk.ukuu.org.uk> <48977200.3050307@shaw.ca> <20080804220619.76b94ceb@lxorguk.ukuu.org.uk> <4898EE70.1030604@shaw.ca> <4898F3EA.7000507@gmail.com>
In-Reply-To: <4898F3EA.7000507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tejun Heo wrote:
>> +unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
>> +			       unsigned int buflen, int rw)
>> +{
>> +	struct ata_port *ap = dev->link->ap;
>> +	void __iomem *data_addr = ap->ioaddr.data_addr;
>> +	unsigned int words = buflen >> 2;
>>     
>
> dwords maybe?
>   

   Isn't word 32-bit in the 32-bit systems? We're not on 80[12]86 
(despite Intel/MS preference of calling 32-bit memory cells DWORDS)...

MBR, Sergei


