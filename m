Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbXINMKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbXINMKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXINMK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:10:26 -0400
Received: from ox.emgs.com ([194.248.190.99]:50199 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbXINMK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:10:26 -0400
Message-ID: <46EA7A2D.90700@pvv.org>
Date: Fri, 14 Sep 2007 14:10:21 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E94728.9050509@garzik.org> <46E951C6.1000403@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org> <46E98ED1.8070109@pvv.org> <46E99572.7080400@garzik.org> <46E9D7DD.30801@shaw.ca>
In-Reply-To: <46E9D7DD.30801@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To eliminate the possibility of this being a hardware issue, I have now 
acquired another "Gigabyte GA-N650SLI-DS4" motherboard (with the "MCP51" 
chipset) for testing. I'll swap parts this evening. Hopefully I'll be 
able to tell you in a few hours whether this appears to be working as it 
should. The motherboard that I'm going to swap to has actually been 
tested (with MS Windows OS+driver) for more than a day with a disk 
connected, so if this MB also fails, I think it will be safe to say that 
the issue is with the sata_nv driver... So hang on.

(You can't think of something else that could conflict with the sata_nv 
driver after a bit of time, like two of my raid-disks being encrypted, 
me running a SW raid-5 array / some special HW (quad-core CPU) / me 
running vmware on this server ... ? - To me, all these suggestions seems 
rather far fetched, especially as all is working with another 
controller, so I'm arguing that unless there's a HW issue, the issue is 
with the driver, but you're the expert(s), so let me know if you differ.)

I'll keep you posted as to the result of swapping HW.. Give me a few 
hours.  :-)

BR
Jon Ivar

Robert Hancock wrote:
> Jeff Garzik wrote:
>> Jon Ivar Rykkelid wrote:
>>> Hi,
>>>
>>> I now tested with the adma=0 option, but if anything I got a crash 
>>> quicker than before. Same error message started coming in, but this 
>>> time the system hung before I was able to capture the log as well 
>>> (but I saw the error, and it was the same as before, except that 
>>> this time it was the ata3-channel that first started acting up..) - 
>>> To remind you all what this is about, I have reattached the log that 
>>> I originally captured...
>>
>> Sounds like a hardware problem, since disabling ADMA is generally the 
>> cure-all we use -- it appears to stress the hardware less.
>
> If this is an MCP51 chipset, adma=0 will make no difference since that 
> chipset does not support ADMA in the first place.
>
