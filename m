Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbXIMVPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbXIMVPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXIMVPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:15:36 -0400
Received: from ox.emgs.com ([194.248.190.99]:45933 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434AbXIMVPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:15:36 -0400
Message-ID: <46E9A874.50305@pvv.org>
Date: Thu, 13 Sep 2007 23:15:32 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E94728.9050509@garzik.org> <46E951C6.1000403@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org> <46E98ED1.8070109@pvv.org> <46E99572.7080400@garzik.org>
In-Reply-To: <46E99572.7080400@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is this the general opinion? - Should I try to get a replacement 
motherboard of the same type?

If so, can anyone confirm that the sata_nv-driver is working with the 
Gigabyte GA-N650SLI-DS4 motherboard at all / have anyone been successful 
with this MB? How about the MCP51 SATA controller? - Can anyone confirm 
that the driver is working for this HW? I would feel awkward to try to 
claim a warranty replacement if it is proved that the HW is OK after 
all, and the problem is with the linux-driver...

BR
Jon Ivar

Jeff Garzik wrote:
> Jon Ivar Rykkelid wrote:
>> Hi,
>>
>> I now tested with the adma=0 option, but if anything I got a crash 
>> quicker than before. Same error message started coming in, but this 
>> time the system hung before I was able to capture the log as well 
>> (but I saw the error, and it was the same as before, except that this 
>> time it was the ata3-channel that first started acting up..) - To 
>> remind you all what this is about, I have reattached the log that I 
>> originally captured...
>
> Sounds like a hardware problem, since disabling ADMA is generally the 
> cure-all we use -- it appears to stress the hardware less.
>
>     Jeff
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Ivar Rykkelid                     Web: http://www.pvv.org/~jonry
Enromvegen 191                        Phone:     +47 72 56 86 86
N-7026 Trondheim                      Mob.:      +47 906 20 250
Norway                                Email:     jonry@pvv.org

