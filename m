Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbXJ3Qwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbXJ3Qwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbXJ3Qwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:52:33 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40426 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXJ3Qwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:52:32 -0400
Message-ID: <47275FD0.4010400@student.ltu.se>
Date: Tue, 30 Oct 2007 17:46:08 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/dpt_i2o: Convert to generic boolean
References: <20071030104806.30936.13253.sendpatchset@thinktank.campus.ltu.se> <20071030145155.GL32359@parisc-linux.org> <47274781.3030606@student.ltu.se> <20071030151121.GM32359@parisc-linux.org>
In-Reply-To: <20071030151121.GM32359@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Oct 30, 2007 at 04:02:25PM +0100, Richard Knutsson wrote:
>   
>> Matthew Wilcox wrote:
>>     
>>> On Tue, Oct 30, 2007 at 11:54:22AM +0100, Richard Knutsson wrote:
>>>  
>>>       
>>>> Convert to use the generic boolean.
>>>> -	u8 initialized;
>>>> -	u8 in_use;		/* is the management node open*/
>>>> +	bool initialized:8;
>>>> +	bool in_use:8;		/* is the management node open*/
>>>>    
>>>>         
>>> Are you serious?
>>>  
>>>       
>> Well, yes. It is since it was defined to really be 8 bits before, and 
>> there is no reason why a boolean would be 8 bits and not 1 or 16.
>> If it is overly cautious/not needed, then I don't mind removing the ':8'...
>>     
>
> What's wrong with leaving it as 'u8'?
>   
I just don't see the reason why expressing a boolean as an integer. Some 
advantage?
(also helps us if someone does: 'if (var == true)', even thou we should 
try to avoid them)

