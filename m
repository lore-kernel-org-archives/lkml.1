Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbXKHG4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbXKHG4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXKHG4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:56:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:16332 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbXKHG4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hI06NsaApk5Ghb7ZtOsg1Hen+8Xskn/1bfuVljYptlUOvJRvHrABXfWDuXvI3bMtLT1U/Eprk4pkZSWgM/VI3upthDHAP9PVc3ffjD3Vn2w7WU+FfCjdDXMhesmx0CSKXvmxSSwlK/dyjtcNExWz8DqVHJZwoqBeypS7ny5LF6o=
Message-ID: <4732B2FB.6000007@gmail.com>
Date: Thu, 08 Nov 2007 15:55:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Peter Osterlund <petero2@telia.com>, Thomas Maier <balagi@justmail.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pktcdvd: fix BUG caused by sysfs module reference	semantics
 change
References: <20071105092018.GD5359@kernel.dk> <Pine.LNX.4.64.0711052312410.5445@quad.localdomain> <47302E9F.6020708@gmail.com> <op.t1d2aurziudtyh@master> <Pine.LNX.4.64.0711062229490.5800@quad.localdomain> <4731269B.6010509@gmail.com> <Pine.LNX.4.64.0711072303080.6991@quad.localdomain> <47327404.9010008@gmail.com> <20071108052418.GA5670@suse.de>
In-Reply-To: <20071108052418.GA5670@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Nov 08, 2007 at 11:27:16AM +0900, Tejun Heo wrote:
>> pkt_setup_dev() expects module reference to be held on invocation.
>> This used to be true for sysfs callbacks but not anymore.  Test and
>> grab module reference around pkt_setup_dev() in
>> class_pktcdvd_store_add().
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> Acked-by: Peter Osterlund <petero2@telia.com>
>> ---
>> Greg, can you please push this patch through your tree? 
>> Thanks a lot.
>>
>>  drivers/block/pktcdvd.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
> 
> Why through my tree?  I don't do block devices :)

Because it's a regression introduced by changes in sysfs?

> Shouldn't Jens or at least Andrew take it?

That's fine too.  Jens?

-- 
tejun
