Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbXBWAVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbXBWAVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXBWAVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:21:44 -0500
Received: from x8.develooper.com ([216.52.237.208]:46520 "EHLO
	x8.develooper.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXBWAVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:21:43 -0500
In-Reply-To: <45DE32E7.1010901@shaw.ca>
References: <45DD2EC9.4050403@shaw.ca> <45DD3EC7.3050801@garzik.org> <3A2F4CD2-EF4C-4C5D-B1B3-A9C89BA9682C@develooper.com> <45DE32E7.1010901@shaw.ca>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FE56076A-03A5-429C-A9A0-BBF2CEAA5DA8@develooper.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Tejun Heo <htejun@gmail.com>, "Eric D. Mudama" <edmudama@gmail.com>
Content-Transfer-Encoding: 7bit
From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image Windows driver
Date: Thu, 22 Feb 2007 16:21:41 -0800
To: Robert Hancock <hancockr@shaw.ca>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 22, 2007, at 4:18 PM, Robert Hancock wrote:

>> model and (partial) firmware revision of the drives:
>> Maxtor 7V300F0  VA11
>> Maxtor 7B300S0  BANC
>> Until I disabled NCQ I got gazillions of messages like the ones  
>> below and absymal performance.
>>   - ask
>> ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995  
>> sactive 0xf)
>
> Sounds like those are some that we should be blacklisting as well,  
> unless Eric has a good reason why not (CCing). Can you provide the  
> full firmware revision strings from those drives, i.e. from "hdparm  
> -I"?

ATA device, with non-removable media
         Model Number:       Maxtor 7B300S0
         Firmware Revision:  BANC1B70

ATA device, with non-removable media
         Model Number:       Maxtor 7V300F0
         Firmware Revision:  VA111630


  - ask

-- 
http://develooper.com/ - http://askask.com/


