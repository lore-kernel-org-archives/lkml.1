Return-Path: <linux-kernel-owner+w=401wt.eu-S1946765AbXD3UWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946765AbXD3UWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946764AbXD3UWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:22:23 -0400
Received: from smtpout10-04.prod.mesa1.secureserver.net ([64.202.165.238]:55010
	"HELO smtpout10.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1946765AbXD3UWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:22:21 -0400
Message-ID: <46364FFA.9050500@seclark.us>
Date: Mon, 30 Apr 2007 16:22:18 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20070429161542.GA12501@havoc.gtf.org> <46364901.4000907@redhat.com> <46364C04.4050208@garzik.org>
In-Reply-To: <46364C04.4050208@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>Chuck Ebbert wrote:
>  
>
>>Jeff Garzik wrote:
>>    
>>
>>>Jeff Garzik (8):
>>>      libata/IDE: remove combined mode quirk
>>>      
>>>
>>You can't just remove the "combined_mode=" kernel parameter or
>>every Linux user who uses that will get an unbootable kernel
>>with no good way of diagnosing the problem. It should still
>>be accepted and just print a warning.
>>    
>>
>
>No, most modern distros will simply Just Work(tm) due to mount by label, 
>udev, and similar gadgets.
>
>As long as you have at least one (if not both) ATA drivers, you have a 
>kernel that will boot your hardware.  And by definition those using 
>combined_mode= do indeed have the necessary drivers.
>
>	Jeff
>
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
Please don't do this!

Yeah the kernel will boot but the hd performance is sh*t on my laptop. I 
am running FC6 with
kernel 2.6.21 and without the combined_mode setting my disk performance 
goes down to a
whopping 1.25mb/sec from 44mb/sec when I boot with combined_mode=libata. 
It make my
system unusable!

Regards,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



