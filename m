Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZAISXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZAISXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZAISW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:22:58 -0500
Received: from nlpi042.sbcis.sbc.com ([207.115.36.71]:58869 "EHLO
	nlpi042.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZAISW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:22:57 -0500
Message-ID: <4967977E.5010504@softplc.com>
Date: Fri, 09 Jan 2009 12:29:18 -0600
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: New true IDE compact flash driver starting point?
References: <49659E41.5070001@softplc.com> <200901081318.44188.arnd@arndb.de> <49661B0F.6030206@softplc.com> <200901091733.16931.arnd@arndb.de>
In-Reply-To: <200901091733.16931.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 08 January 2009, Dick Hollenbeck wrote:
>   
>> I've done something similar to this for 8250 serial ports, but I am 
>> having a difficult time finding out how to do this with pata_platform.c
>>
>>     
>
> Just grep for pata_platform_info to find example code.
>
> 	Arnd <><
>   
Thanks again Arnd.  I did that yesterday and got it working last night!  
The only thing I have questions about are:


1) Since this is for a quasi realtime application, is there any 
advantage to using the interrupt line regarding how the CPU spends its 
idle time waiting for the flash?  (I have an interrupt line I can use.)  
Currently I am not sending in the IRQ resource, resource array length of 
2, not 3.


2) I am getting this message during boot up:  "Driver 'sd' needs 
updating - please use bus_type methods".   Again this is kernel 2.6.26.  
It seems like this can be safely ignored, but if its easy to get rid of 
that I would be happy to back port a patch.



I really appreciate your help.

Dick Hollenbeck

