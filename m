Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbXFUXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbXFUXC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXFUXCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:02:12 -0400
Received: from arx.rabbit.us ([68.251.127.6]:4895 "EHLO arx.rabbit.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXFUXCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:02:10 -0400
Message-ID: <467B036D.4050100@rabbit.us>
Date: Fri, 22 Jun 2007 01:02:05 +0200
From: Peter Rabbitson <rabbit@rabbit.us>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Terrible IO performance when using 4GB of RAM on a 32 bit machine
References: <467AB4CF.7030904@rabbit.us> <467AD101.4020107@zytor.com>
In-Reply-To: <467AD101.4020107@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Peter Rabbitson wrote:
>> I have captured dmesg output without mem[5], with mem=3900M[6] and
>> mem=2048M[7].
>>
> 
> What does /proc/mtrr look like in the two cases?
> 

Identical for mem=3900 and without it.

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1 

reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1 

reg02: base=0xc0000000 (3072MB), size= 512MB: write-back, count=1 

reg03: base=0xe0000000 (3584MB), size= 256MB: write-back, count=1 

reg04: base=0xf0000000 (3840MB), size= 128MB: write-back, count=1 

reg05: base=0xf8000000 (3968MB), size=  32MB: write-back, count=1 


Peter
