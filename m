Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXCHVKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXCHVKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXCHVKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:10:04 -0500
Received: from mtaout3.012.net.il ([84.95.2.7]:19120 "EHLO mtaout3.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327AbXCHVKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:10:03 -0500
Date: Thu, 08 Mar 2007 23:08:51 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: PAGE_SIZE Availability Inconsistency
In-reply-to: <45ECD03F.2040008@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, dmlb2000@gmail.com,
       linux-kernel@vger.kernel.org
Message-id: <45F07B63.1000105@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 08 Mar 2007 23:08:51 +0200 (IST)
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
 <20070305.160303.59493440.davem@davemloft.net>
 <9c21eeae0703051604l20a029c3r8cf09d792ba523be@mail.gmail.com>
 <20070305.162620.04006691.davem@davemloft.net> <45ECD03F.2040008@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> David Miller wrote:
>>>>
>>> Thanks, but that still leaves PAGE_SIZE available for some
>>> architectures and not for others shouldn't this be moved inside
>>> __KERNEL__ in i386 and x86_64 then?
>>
>> I definitely think so.
>
> It definitely should, especially on x86-64, where the page size isn't 
> guaranteed by the ABI (on i386, the ABI guarantees a 4K page size; on 
> x86-64 it can be up to 64K.)
>

Wouldn't that be ia64?


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

