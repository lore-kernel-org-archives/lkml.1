Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbXBCXP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbXBCXP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXBCXP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:15:28 -0500
Received: from smtpauth01.prod.mesa1.secureserver.net ([64.202.165.181]:33561
	"HELO smtpauth01.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751837AbXBCXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:15:27 -0500
Message-ID: <45C5178A.1000501@seclark.us>
Date: Sat, 03 Feb 2007 18:15:22 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Patrick Ale <patrick.ale@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no> <45C4DF2A.1070501@shaw.ca>
In-Reply-To: <45C4DF2A.1070501@shaw.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:

>>Hi guys,
>>
>>Me again, sorry.
>>
>>Is it possible to make hdparm work with libata?
>>I have some drives that for some reason fall back to lower UDMA
>>settings (like UDMA/44) while the drive is UDMA/100. I blame the way I
>>set-up my raid arrays for this and the bus not being able to handle
>>all the data that goes trough it but that isnt really the case now.
>>
>>Anyway, I used to be able to force the drive back with using hdparm
>>-X68 -d 1 /dev/sdk
>>But with the new lib_pata drivers I get "Inappropriate iotcl for
>>device" and HD_IO_DRIVE_CMD Input/Output errors.
>>
>>Or! Is there some other way to force the drive not to failback to
>>lower UDMA settings? (Yep, I know, if this is answer, it's my risk, I
>>cant and wont blame you for destructing my pr0n or severe trauma I
>>suffer from losing data)
>>    
>>
>
>Only some of the hdparm functionality is supported in libata, which is 
>partially by design. Presently there's no way to override the DMA 
>settings in libata, it starts out at the fastest supported settings and 
>falls back if it gets too many errors of certain types.
>
>You shouldn't be seeing errors like this unless you have bad IDE cables 
>or are using 40-wire cables with high UDMA modes. Can you post the 
>output you're seeing?
>
>  
>
Ok,

But why are we taking away the users capability to control his/her own 
hardware. Sounds like windows.

My $.02
Steve Clark

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



