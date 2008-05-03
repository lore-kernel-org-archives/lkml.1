Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYECCiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYECCiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 22:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYECCiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 22:38:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9137 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYECCiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 22:38:12 -0400
Date: Fri, 02 May 2008 20:38:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata - DMA problems ICH7 rev 02
In-reply-to: <fa.h4D6h2c4Yz08K7snVTVtewbsziM@ifi.uio.no>
To: Jan Niklas Hasse <jhasse@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Message-id: <481BD00E.7050302@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6VoLd5Q2gfHHZZfYneNkQcGjXKk@ifi.uio.no>
 <fa.kzdMLVO0bqLAbXEBqWrKyBntgxc@ifi.uio.no>
 <fa.h4D6h2c4Yz08K7snVTVtewbsziM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Niklas Hasse wrote:
> On Fri, May 2, 2008 at 2:58 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> my BIOS didn't support it), but none of them worked (every time my
>>  > harddisk is loading my CPU is spammed with IOWait).
>>
>>  Then you must have a different problem ?
> 
> Maybe, but it seems as DMA isn't used. Everytime my hard disk is
> reading/writing my system gets very slow. Here's the line when i run
> top:
> 
> Cpu(s): 12.6%us,  5.4%sy,  0.0%ni,  6.5%id, 74.2%wa,  0.5%hi,  0.8%si,  0.0%st
> 
> The thing I mean is "wa".

This is expected. IOWait just means the system is blocked waiting for IO 
  and has nothing else to do. It does not mean that DMA is not working.

> 
>>  > Output of uname -a and lspci is attached.
>>  >
>>  > I hope you can help me, very hard to work without DMA.
>>
>>  Please send the output of "dmesg" after boot
> 
> Okay, I pasted it here: http://rafb.net/p/KiWhqE72.html

Looks like you are using DMA:

ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
