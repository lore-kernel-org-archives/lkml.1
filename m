Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbXINAiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbXINAiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 20:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbXINAiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 20:38:10 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:16427 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXINAiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 20:38:09 -0400
Date: Thu, 13 Sep 2007 18:37:49 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv issues with MCP51 SATA controller
In-reply-to: <46E99572.7080400@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jon Ivar Rykkelid <jonry@pvv.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org
Message-id: <46E9D7DD.30801@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <46E8EABF.3060409@pvv.org> <46E94728.9050509@garzik.org>
 <46E951C6.1000403@pvv.org> <46E953D7.5070305@gmail.com>
 <46E97AFF.30202@pvv.org> <46E98ED1.8070109@pvv.org>
 <46E99572.7080400@garzik.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jon Ivar Rykkelid wrote:
>> Hi,
>>
>> I now tested with the adma=0 option, but if anything I got a crash 
>> quicker than before. Same error message started coming in, but this 
>> time the system hung before I was able to capture the log as well (but 
>> I saw the error, and it was the same as before, except that this time 
>> it was the ata3-channel that first started acting up..) - To remind 
>> you all what this is about, I have reattached the log that I 
>> originally captured...
> 
> Sounds like a hardware problem, since disabling ADMA is generally the 
> cure-all we use -- it appears to stress the hardware less.

If this is an MCP51 chipset, adma=0 will make no difference since that 
chipset does not support ADMA in the first place.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

