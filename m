Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab0CNQCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:02:10 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:29408 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752532Ab0CNQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:02:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAM6lnEtLd/sX/2dsb2JhbAAHgwW/RI8FgTKBFIFLagQ
X-IronPort-AV: E=Sophos;i="4.49,639,1262581200"; 
   d="scan'208";a="58223378"
Message-ID: <4B9D0879.5050809@teksavvy.com>
Date: Sun, 14 Mar 2010 12:02:01 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, foo saa <foosaa@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-mm@kvack.org
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
 program
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>	 <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>	 <4B8FC6AC.4060801@teksavvy.com> <87f94c371003111029s7c7daebgf691ab11e6bdda25@mail.gmail.com>
In-Reply-To: <87f94c371003111029s7c7daebgf691ab11e6bdda25@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/10 13:29, Greg Freemyer wrote:
>>
>> But really.. isn't "hdparm --security-erase NULL /dev/sdX" good enough ???
>>
>
> This thread seems to have died off.  If there is a real problem, I
> hope it picks back up.
>
> Mark, as to your question the few times I've tried that the bios on
> the test machine blocked the command.  So it may have some specific
> utility, but it's a not a generic solution in my mind.
..

Yeah, a lot of BIOSs do a "SECURITY FREEZE" command before booting,
which disables things like "SECURITY ERASE" until the next hard reset.

So, on a Linux system, just unplug the drive after booting, replug it,
and usually it can then be erased.

But yeah.. that all makes things tricker for non-techies.

Cheers
