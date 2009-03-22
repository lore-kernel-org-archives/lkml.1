Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZCVBVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZCVBVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 21:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZCVBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 21:20:54 -0400
Received: from main.gmane.org ([80.91.229.2]:49020 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZCVBUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 21:20:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: ATA support for 4k sector size
Date: Sat, 21 Mar 2009 21:20:40 -0400
Message-ID: <gq43p9$505$1@ger.gmane.org>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	 <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <20090226025043.GJ1363@mit.edu>	 <20090226030735.GA16891@parisc-linux.org>	 <yq1eixlg4mn.fsf@sermon.lab.mkp.net> <49A6B604.1060702@zytor.com>	 <yq1iqmxey1o.fsf@sermon.lab.mkp.net> <49A70379.3050306@zytor.com>	 <87f94c370903160751t6de5ed2t40163a6590ba633@mail.gmail.com>	 <49BE7DEF.1060005@zytor.com> <87f94c370903161037q52ff5e1nb7512726e58e652c@mail.gmail.com> <49BE9643.8050703@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-70-109-119-176.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <49BE9643.8050703@zytor.com>
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Greg Freemyer wrote:
>>
>> I'm not intimate with the details, but I would hope most boot loaders
>> by now use LBA values to find the boot code, not CHS.
>>
> 
> Yes, for "true" hard drives this is pretty much universal these days 
> (except for MS-DOS and its ilk.)  For USB and so on some BIOSes are 
> still stuck in old times.  Sigh.
> 
>> If so the issue becomes the partitioning tools (fdisk etc.) putting
>> the partitions at the right place.  Can't those tools bypass the bios
>> somehow and ask the drive itself what it's geometry is?
> 
> It can, but it MUST NOT do so.  The fields that are to be entered into 
> the partition table are BIOS CHS values, not any other kind of CHS.
> 
I can recall playing with the disk "geometry" in the expert part of fdisk and 
not getting any particular bad effects, so I'm not sure why you MUST NOT other 
than the SSD you mentioned. However, the reason it was long ago is that aligning 
things in some possibly batter way didn't make a measurable difference in 
performance, so I went back to defaults, so I agree with your advice, it doesn't 
seem to help.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

