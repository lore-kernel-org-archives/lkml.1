Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXKJUZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXKJUZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbXKJUZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:25:16 -0500
Received: from smtpout06-04.prod.mesa1.secureserver.net ([64.202.165.227]:33882
	"HELO smtpout06.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753763AbXKJUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:25:14 -0500
Message-ID: <473613A5.6000004@seclark.us>
Date: Sat, 10 Nov 2007 15:25:09 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Laptop's HDD
References: <200711040002.25784.info@gnebu.es> <Pine.LNX.4.64N.0711091416570.914@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711091416570.914@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:

>On Sun, 4 Nov 2007, Alberto Gonzalez wrote:
>
>  
>
>>The problem comes from a very high rate of load/unload cycles of the heads 
>>that reaches the 300.000-600.000 limit in 2-3 years (with smartmontools it 
>>can checked it with "smartctl -A /dev/sda")  . There are reports of HDD dying 
>>even earlier for this problem [2]
>>    
>>
>
> I use:
>
># hdparm -B 255 /dev/hda
>
>to get rid of the problem with an ATA disk where I do not care that much 
>about power consumption.  I do not know what the equivalent for a SATA 
>disk would be, but chances are it will be easier to track it down with the 
>reference above.
>
>  Maciej
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
My laptop harddrive is only a little over a year old and it has a cycle 
count of 193 Load_Cycle_Count        0x0012   021   021   000    
Old_age   Always       -       795931

it was going up a few counts everytime I ran the smartctl -A command. It 
quit incrementing after
I did the hdparm -B 255 command.

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



