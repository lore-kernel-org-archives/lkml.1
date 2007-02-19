Return-Path: <linux-kernel-owner+w=401wt.eu-S965101AbXBSW2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101AbXBSW2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965104AbXBSW2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:28:05 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:47044 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965101AbXBSW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:28:04 -0500
In-Reply-To: <87ejolkcyt.fsf@duaron.myhome.or.jp>
References: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org> <87vehzqwf6.fsf@duaron.myhome.or.jp> <04C493C2-1D8D-41B7-955A-F5C5B08023BB@kernel.crashing.org> <87ejolkcyt.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3D8A0565-36F9-4216-839E-4B4815E9AC78@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
Date: Mon, 19 Feb 2007 16:27:03 -0600
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19, 2007, at 4:19 PM, OGAWA Hirofumi wrote:

> Kumar Gala <galak@kernel.crashing.org> writes:
>
>>>> I usually run the following twice to get the hang state:
>>>>
>>>> time ./trunc_test bar 100000000 &
>>>> time ./trunc_test baz 100000000 &
>>>>
>>>> I was wondering if anyone had any suggestions on what to poke at  
>>>> next
>>>> to try and figure out what is going on.
>>>
>>> Can you check /sys/block/xxx/stat or something to make sure there is
>>> no outstanding IO request?
>>>
>>> It seems to be no response from the lower layer...
>>
>> Once the system locks up I dont have any ability to do anything.
>
> Ah, doesn't sysrq also work? If sysrq work, it can use to see IO
> request state with a patch.

Yeah, got sysrq working today.  If you can point me at the patch I  
happy to apply it and get data.

- k

