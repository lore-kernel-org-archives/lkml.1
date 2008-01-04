Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbYADCxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbYADCxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYADCwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:52:53 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:27195 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYADCww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:52:52 -0500
Date: Thu, 03 Jan 2008 20:51:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <F72FA20C31DD4F4C997B91C5B3690A09505598@hqemmail07.nvidia.com>
To: Allen Martin <AMartin@nvidia.com>
Cc: Mark Lord <lkml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>, Peer Chen <pchen@nvidia.com>
Message-id: <477D9F4D.5030807@shaw.ca>
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

That answers that question, I guess. Still guessing at why the 
controller would get stuck in IDLE state with no interrupt raised, then..
