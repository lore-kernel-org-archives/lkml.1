Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXEZAPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXEZAPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 20:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbXEZAP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 20:15:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59289 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXEZAP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 20:15:26 -0400
Message-ID: <46577C18.8000602@garzik.org>
Date: Fri, 25 May 2007 20:15:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [git patches] libata fixes
References: <200705260006.l4Q06GsK020585@harpo.it.uu.se>
In-Reply-To: <200705260006.l4Q06GsK020585@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> On Fri, 25 May 2007 18:03:07 -0400, Jeff Garzik wrote:
>> Jeff Garzik (4):
>>      [libata] sata_promise: fix flags typo
> ...
>> --- a/drivers/ata/sata_promise.c
>> +++ b/drivers/ata/sata_promise.c
>> @@ -297,7 +297,7 @@ static const struct ata_port_info pdc_port_info[] = {
>>
>> 	/* board_2057x_pata */
>> 	{
>> -		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
>> +		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS |
>> 				  PDC_FLAG_GEN_II,
>> 		.pio_mask	= 0x1f, /* pio0-4 */
>> 		.mwdma_mask	= 0x07, /* mwdma0-2 */
> 
> Acked-by: Mikael Pettersson <mikpe@it.uu.se>
> 
> Good catch. This typo would have prevented pdc_host_intr()
> from detecting GEN_II-specific errors on the PATA port.

Oops -- I should have credited Al Viro for the catch, in the changelog.

This email hereby corrects the record :)

	Jeff


