Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbXBDALK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbXBDALK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXBDALK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:11:10 -0500
Received: from smtpauth03.prod.mesa1.secureserver.net ([64.202.165.183]:45059
	"HELO smtpauth03.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751723AbXBDALJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:11:09 -0500
Message-ID: <45C5249B.8020101@seclark.us>
Date: Sat, 03 Feb 2007 19:11:07 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Patrick Ale <patrick.ale@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>	 <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us> <8d158e1f0702031544h6c5f81c7s3c54a6192255d447@mail.gmail.com>
In-Reply-To: <8d158e1f0702031544h6c5f81c7s3c54a6192255d447@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:

>On 2/4/07, Stephen Clark <Stephen.Clark@seclark.us> wrote:
>  
>
>>Robert Hancock wrote:
>>    
>>
>
>  
>
>>But why are we taking away the users capability to control his/her own
>>hardware. Sounds like windows.
>>    
>>
>
>I wouldn't go as far as making that comparsion, most of all cause it's
>totaly invalid, with all respect.
>
>In my opinion the new pata drivers are work in progress, they only
>appear in the latest kernel and snapshots so please, let's allow the
>drivers to evolve, I am no kernel hacker or coder, nor does my
>interest lay here at the moment to be honest, I am a system
>administrator working with Unix and Linux and am interested in helping
>out where I can. By using the new pata drivers in favor of the old IDE
>drivers I took a risk, well calculated and with the very thought of
>encountering these kind of problems and reporting them to make things
>better.
>
>However, I do have to agree with the point that if the drivers/kernel,
>for whatever reason they might have, to switch to a lower UDMA mode,
>and when none is left, even to PIO mode, I should have at least the
>chance to switch back to a higher level of datatransfer speed.
>
>How it looks now is that the kernel and its drivers treat the devices
>as ATA devices with their features, but the userland programs like
>hdparm and sdparm and blkutil see the devices as SCSI/SATA devices,
>and dont allow the ioctl commands which are valid for ATA drives.
>
>Just my two euros/canadian dollars/croatian kunas in the pocket :)
>
>Patrick
>
>  
>
My point is that the driver can't be tested on every combination of 
hardware, so if the user
doesn't have the capability to override assumptions the driver makes 
then he is stuck.

I have had two different laptops that had to have boot time command line 
overrides to get the
driver to allow the hardware work at what it was spec-ed at.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



