Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbXLGB3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbXLGB3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 20:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXLGB3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 20:29:37 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60495 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXLGB3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 20:29:36 -0500
Message-ID: <4758A1E7.9010201@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2007 06:59:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>
CC: Greg KH <greg@kroah.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, rsa@us.ibm.com, apw@shadowen.org,
       balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on powerpc
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com> <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com> <47584672.8040201@linux.vnet.ibm.com> <1196968880.18388.5.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1196968880.18388.5.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> On Fri, 2007-12-07 at 00:28 +0530, Balbir Singh wrote:
>> Greg KH wrote:
>>
>>>> Why release the spinlock here? It's done after the count is incremented.
>>>> This patch does not seem correct.
>>> Doh, you are correct, I'll make sure that I fix this up before applying
>>> it.
>>>
>>> thanks,
>>>
>>> greg k-h
>> Hi, Greg,
>>
>> I ran some tests with the fixed up version of this patch and the system
>> fails to come up.
>>
>> I see the WARN_ON in lib/kref.c:33 and the system fails to boot beyond
>> that point. I have not yet found time to debug it though.
> 
> 
> Are you running into same issue, I am getting on my machine ? Are you
> using IPR driver ?
> 

Badari,

I am unable to get past lib/kref.c:33 and cut here. The machine just
stalls, I see no output at the console. I don't get a backtrace like you
do, even with xmon enabled :(

> Thanks,
> Badari
> 
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
