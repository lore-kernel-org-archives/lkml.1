Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZIUNcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZIUNcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZIUNcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:32:00 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58060 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756158AbZIUNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:31:59 -0400
Date: Mon, 21 Sep 2009 09:32:03 -0400
To: michal.simek@petalogix.com
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] Actually show KiB rather than pages in "Freeing initrd
	memory:" message on microblaze.
Message-ID: <20090921133203.GZ23700@csclub.uwaterloo.ca>
References: <20090915165037.GA23702@csclub.uwaterloo.ca> <20090917154623.GD23702@csclub.uwaterloo.ca> <20090917154706.GE23702@csclub.uwaterloo.ca> <4AB773F6.7090901@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB773F6.7090901@petalogix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 02:39:18PM +0200, Michal Simek wrote:
> Added to next branch.
>
> There were some problems which I fixed.
> 1. long first description
> 2. missing microblaze: at the beginning

Missing what?

> 3. line longer than 80chars

Hmm, I thought for sure I had checkpatch.pl claiming all my lines
were OK.  Odd.  Clearly the one below is longer though.  How strange.

>
> Lennart Sorensen wrote:
>> Fix "Freeing initrd memory:" message on microblaze to show kilobytes as
>> claimed rather than number of pages.
>>
>> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
>>
>> diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
>> index f207f1a..ed5f96b 100644
>> --- a/arch/microblaze/mm/init.c
>> +++ b/arch/microblaze/mm/init.c
>> @@ -180,7 +180,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>>  		totalram_pages++;
>>  		pages++;
>>  	}
>> -	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
>> +	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
>>  }
>>  #endif
>>  

-- 
Len Sorensen
