Return-Path: <linux-kernel-owner+w=401wt.eu-S1750718AbXBVMuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750718AbXBVMuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXBVMuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:50:24 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:8407 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXBVMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:50:23 -0500
Message-ID: <45DD917D.5010807@chelsio.com>
Date: Thu, 22 Feb 2007 04:50:05 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: yoshfuji@linux-ipv6.org
CC: divy@chelsio.com, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 2/7] cxgb3 - private ioctl cleanup
References: <20070222115925.10001.61276.stgit@localhost.localdomain>	<20070222.210618.134161490.yoshfuji@linux-ipv6.org>	<45DD8DDA.8060303@chelsio.com> <20070222.213915.89824941.yoshfuji@linux-ipv6.org>
In-Reply-To: <20070222.213915.89824941.yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2007 12:50:09.0088 (UTC) FILETIME=[FBEE4400:01C7567F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / $B5HF#1QL@ wrote:
> In article <45DD8DDA.8060303@chelsio.com> (at Thu, 22 Feb 2007 04:34:34 -0800), Divy Le Ray <divy@chelsio.com> says:
>
>
>   
>>> 1. Please do do change the values.
>>> 2. Explain why you are going to kill these ioctls.
>>>   
>>>       
>> Jeff and Arjan have required that most of these ioctls go.
>> Please read:
>> http://marc.theaimsgroup.com/?l=linux-netdev&m=117029584904193&w=2
>>     
>
> Even if you remove them, PLEASE DO NOT CHANGE THE VALUES,
> unless you have very, very good reason.
>   

The cxgb3 driver has not yet appeared in a stable version of the linux 
kernel.
The odds of breaking an application using these private ioctls are 
pretty slim.
Since some cleanup was required, I chose not to let holes between the 
values.

Cheers,
Divy


