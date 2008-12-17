Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752391AbYLQS6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYLQS6z (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYLQS6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:58:42 -0500
Received: from mirapoint3.brutele.be ([212.68.199.148]:17054 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYLQS6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:58:41 -0500
Message-ID: <49494BDB.1000100@tvcablenet.be>
Date: Wed, 17 Dec 2008 19:58:35 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Thunderbird 2.0.0.18 (X11/20081123)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/83] 2.6.27.9-stable review
References: <20081211191014.GA5759@suse.de> <49438093.9030809@tvcablenet.be> <20081216232530.GA11262@suse.de>
In-Reply-To: <20081216232530.GA11262@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Junkmail-Status: score=10/50, host=mirapoint3.brutele.be
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0203.49494BDC.01F4,ss=1,fgs=0,
	ip=192.168.1.2,
	so=2008-05-01 23:44:25,
	dmn=5.7.1/2008-09-02
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH a écrit :
> On Sat, Dec 13, 2008 at 10:29:55AM +0100, François Valenduc wrote:
>   
>> Greg KH a écrit :
>>     
>>> This is the start of the stable review cycle for the 2.6.27.9 release.
>>> There are 83 patches in this series, all will be posted as a response to
>>> this one.  If anyone has any issues with these being applied, please let
>>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>>> to add a Signed-off-by: line to the patch, please respond with it.
>>> These patches are sent out with a number of different people on the Cc:
>>> line.  If you wish to be a reviewer, please email stable@kernel.org to
>>> add your name to the list.  If you want to be off the reviewer list,
>>> also email us.
>>> Responses should be made by December 13, 2008, 20:00:00 UTC.
>>> Anything received after that time might be too late.
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.9-rc1.gz
>>> and the diffstat can be found below.
>>> thanks,
>>> greg k-h
>>>       
>> Would it be possible to add these two patches ?
>>
>> commit 8258becf07e71236aac8cf5406a1345712f9ac25
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Tue Sep 23 19:18:43 2008 +0200
>>
>>     iwlagn: downgrade BUG_ON in interrupt
>>
>> commit 199d9de726ff2f949405279665a9c8b38966239b
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Tue Nov 18 01:47:21 2008 +0100
>>
>>     iwlagn: fix RX skb alignment
>>
>> Without these ones, my computer freezes very frequently (see bugs 11393, 
>> 11983 and 12173 which in fact is a duplicate of the previous one).
>> These two patches can be applied without any rejects on kernel 2.6.27.8.
>>     
>
> I don't see these patches in Linus's kernel tree.  Are they not there?
>
> Or if they are there, can you give me the correct git commit ids for
> them?
>
> thanks,
>
> greg k-h
>
>   

These commit ids are indeed not the one of linus's tree and they
correspond to my local tree for kernel 2.6.27. The correct ids should
be  4018517a1a69a85c3d61b20fa02f187b80773137 and 
55d6a3cd0cc85ed90c39cf32e16f622bd003117b.

François
