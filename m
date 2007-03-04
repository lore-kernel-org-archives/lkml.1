Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbXCDSOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbXCDSOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 13:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbXCDSOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 13:14:46 -0500
Received: from smtpauth01.prod.mesa1.secureserver.net ([64.202.165.181]:33509
	"HELO smtpauth01.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752179AbXCDSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 13:14:45 -0500
Message-ID: <45EB0C95.1070505@seclark.us>
Date: Sun, 04 Mar 2007 13:14:45 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] libata: warn if speed limited due to 40-wire cable (v2)
References: <45DA44B4.6000209@shaw.ca>	<45E8B42E.7010900@garzik.org> <20070303005433.714d75ad@lxorguk.ukuu.org.uk> <45E9DA80.2080109@tmr.com>
In-Reply-To: <45E9DA80.2080109@tmr.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:

>Alan Cox wrote:
>  
>
>>>it seems broken to manipulate xfer_mask after returning from the 
>>>driver's ->mode_filter hook.
>>>
>>>this patch is more than just a speed-limited warning printk, afaics
>>>      
>>>
>>I actually suggested that order because the only way the printk can be
>>done correctly is for it to be the very last test made. Since the mode
>>filter is not told what mode will be used but just subtracts modes that
>>are not allowed this should be safe.
>>    
>>
>
>Far better to have a drive which works slowly than one which works 
>unreliably.
>
>  
>
That would be true if the 40 wire detection was 100% accurate!

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



