Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbYAHAL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYAHAL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYAHALr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:11:47 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:13875 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYAHALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:11:46 -0500
Date: Mon, 07 Jan 2008 18:10:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <F72FA20C31DD4F4C997B91C5B3690A09505598@hqemmail07.nvidia.com>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Allen Martin <AMartin@nvidia.com>, Mark Lord <lkml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>, Peer Chen <pchen@nvidia.com>
Message-id: <4782BF75.9040803@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
 <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com>
 <477B0CFD.1030603@shaw.ca>
 <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com>
 <477BDEA5.8040701@garzik.org>
 <F72FA20C31DD4F4C997B91C5B3690A0950557D@hqemmail07.nvidia.com>
 <477C2A99.9010208@shaw.ca> <477C61D3.30009@rtr.ca> <477C6A85.9020607@shaw.ca>
 <F72FA20C31DD4F4C997B91C5B3690A09505598@hqemmail07.nvidia.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allen Martin wrote:
>  
>>> Dunno about the NVidia version.
>> Theirs works rather differently - the GO bit is there, but there's 
>> another append register which is used to tell the controller 
>> that a new 
>> tag has been added to the CPB list.
>>
>> The only thing we currently use the GO bit for is to switch 
>> between ADMA 
>> and port register mode. Could be there's something we need to 
>> do there, 
>> though, who knows..
>>
> 
> You shouldn't ever need to touch GO other than the ADMA / legacy mode
> switch as you say.
> 
> The NVIDIA ADMA hw is not based on the Pacific Digital core.

Gabor, I just noticed you said that it worked OK in 2.6.20, yet 2.6.22 
fails. 2.6.20 had ADMA support as well, so I wonder what change started 
causing the problem. Would it be possible for you to do a git bisect (or 
at least try 2.6.21 to try and narrow it down)?
