Return-Path: <linux-kernel-owner+w=401wt.eu-S937887AbXHICeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937887AbXHICeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbXHICdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:33:54 -0400
Received: from vscan01.westnet.com.au ([203.10.1.131]:35873 "EHLO
	vscan01.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbXHICdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:33:53 -0400
Message-ID: <46BA7CFB.8020605@parkingdenied.com>
Date: Thu, 09 Aug 2007 10:33:31 +0800
From: Ross Fawcett <claymen@parkingdenied.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_sil24 problems
References: <46BA6E79.8090706@parkingdenied.com> <46BA7ACB.20706@garzik.org>
In-Reply-To: <46BA7ACB.20706@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2007 02:33:31.0347 (UTC) FILETIME=[ACF50230:01C7DA2D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What would you define a media error as though? I mean my first thought
is a bad block, but a scan of the disc doesn't report anything like
that. It also seems to be intermittent, however recently it has been
reproducible.

- Ross

Jeff Garzik wrote:
> Ross Fawcett wrote:
>> The errors I get are like these.
>>
>> [ 1073.018375] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
>> [ 1073.018382] ata4.00: (irq_stat 0x00020002, device error via SDB FIS)
>> [ 1073.018389] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
>> cdb 0x0 data 65536 in
>> [ 1073.018391]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
>> 0x9 (media error)
>
>
> Your device is signalling a media error.  That's hardware going
> ker-flop, with the controller happily reporting that fact back to us.
>
>     Jeff
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
