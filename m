Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbZCTTya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbZCTTya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZCTTyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:54:21 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55078 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312AbZCTTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:54:21 -0400
Message-ID: <49C3F41E.60500@vflare.org>
Date: Sat, 21 Mar 2009 01:23:02 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3]: compressed RAM block device
References: <49BF8ABC.6040805@vflare.org> <49BF8B4E.1030603@vflare.org> <20090320185637.GA1418@ucw.cz>
In-Reply-To: <20090320185637.GA1418@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090319-0, 19-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2009-03-17 17:06:46, Nitin Gupta wrote:
>>  drivers/block/Kconfig     |   22 +
>>  drivers/block/Makefile    |    1 +
>>  drivers/block/compcache.c |  995 +++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/block/compcache.h |  160 ++++++++
>>  4 files changed, 1178 insertions(+), 0 deletions(-)
>>
>> Creates RAM based block device (ramzswap0) which can be used as swap device.
>> Pages swapped to this are compressed and stored in memory itself.
>>
>> The module is called compcache.ko. It depends on:
>>  - xvmalloc.ko: memory allocator
>>  - lzo_compress.ko
>>  - lzo_decompress.ko
>>
>> See Documentation/blockdev/compcache.txt for usage details.
>>
>> Project home: http://code.google.com/p/compcache/
> 
> 
> Compcache is really bad name for this. zramdisk? gzrd?
> 
It was named compcache according to its original goal:
compressed caching for anonymous _and_ filesystem caches. This ram block
device is for handling anonymous memory only. Anyway, actual block device
is called ramzswap which you might like more :)

> Is the block device useful for general filesystem storage?
> 
No. It can only handle page aligned I/O. But it shouldn't be too hard
to make it generic compressed ram disk with physical backing device support.
But unfortunately I do not have bandwidth to do this myself.

Thanks,
Nitin

