Return-Path: <linux-kernel-owner+w=401wt.eu-S1031301AbXDJRp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031301AbXDJRp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031298AbXDJRp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:45:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:21473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031301AbXDJRp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:45:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,390,1170662400"; 
   d="scan'208"; a="211147670:sNHT21830620"
Message-ID: <461BCD28.4000104@intel.com>
Date: Tue, 10 Apr 2007 21:45:12 +0400
From: akorolev <alexey.korolev@intel.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Linux 2.4.x MTD CFI P30/P33 support
References: <523F3D8D8C97554AA47E53DF1A05466A666249@nnsmsx411.ccr.corp.intel.com> <20070317064637.GA14739@1wt.eu> <45FECA26.7010905@intel.com>
In-Reply-To: <45FECA26.7010905@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2007 17:45:12.0228 (UTC) FILETIME=[FD3D4E40:01C77B97]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Willy,

What version of linux 2.4.x kernel do you expect P30/P33 support may be 
included?
May be something else I should do in addition. What should I do to get 
the patch included into linux 2.4.x?

Thanks,
Alexey
> Hi Willy,
>
>
>> OK, it seems trivial enough to me. I have no problem merging this. Your
>> mailer has wrapped lines, but I'll fix this by hand.
>>   
> Oh thank you very much. Sorry for wrapped text. I've corrected it.
>
> Signed-off-by: Alexey Korolev <alexey.korolev@intel.com
> ------------------------
> --- a/drivers/mtd/chips/cfi_cmdset_0001.c    2003-06-13 
> 18:51:34.000000000 +0400
> +++ b/drivers/mtd/chips/cfi_cmdset_0001.c    2007-02-16 
> 21:39:50.000000000 +0300
> @@ -152,7 +152,7 @@
>         }
>        
>         if (extp->MajorVersion != '1' || -            
> (extp->MinorVersion < '0' || extp->MinorVersion > '3')) {
> +            (extp->MinorVersion < '0' || extp->MinorVersion > '4')) {
>             printk(KERN_WARNING "  Unknown IntelExt Extended Query "
>                    "version %c.%c.\n",  extp->MajorVersion,
>                    extp->MinorVersion);
> ------------------------
>
> Thanks,
> Alexey
>
>
