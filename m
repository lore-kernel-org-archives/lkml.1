Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbXHGJD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbXHGJD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXHGJDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:03:47 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:47383 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755089AbXHGJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:03:46 -0400
Message-ID: <46B83560.2060107@interia.pl>
Date: Tue, 07 Aug 2007 11:03:28 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net> <46B60FB7.8030301@interia.pl> <200708052142.14630.jimis@gmx.net> <46B748DE.1060108@interia.pl> <46B773F6.7060603@gmx.net> <46B79CDE.2030709@interia.pl> <46B7C18E.1050008@gmx.net>
In-Reply-To: <46B7C18E.1050008@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: a025aacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Just tested (plain curiosity).
>> via82cxxx average result @533MHz:
>> /dev/hda:
>> Timing cached reads:   232 MB in  2.00 seconds = 115.93 MB/sec
>> Timing buffered disk reads:   64 MB in  3.12 seconds =  20.54 MB/sec
>> pata_via average result @533MHz:
>> /dev/sda:
>> Timing cached reads:   234 MB in  2.01 seconds = 116.27 MB/sec
>> Timing buffered disk reads:   82 MB in  3.05 seconds =  26.92 MB/sec
> 
> Interesting! I haven't tried libata myself on that system, I only have 
> remote access to it so I'm a bit afraid...
Just change root=/dev/hda1 to append="root=/dev/sda1" in lilo.conf.
And change fstab. If You don't change "/" then system will go into single 
user mode after reboot.
> Rafal, I hope that system you run hdparm on isn't the archlinux one! Is 
> it easy to load an old kernel (even two years old) and do the same test? 
> If it is, please let me know of the results.
I don't think it is possible. If I remember right kernel can't be older  
then glibc kernel headers.
Btw. My disk is 20GB 2,5" ATA33. I wonder how 26MB/s is possible. I don't 
expect more.
> 
> Thanks in advance,
> Dimitris
Regards
Rafał

----------------------------------------------------------------------
Wszystko czego potrzebujesz latem: kremy do opalania, 
stroje kapielowe, maly romans 

>>>http://link.interia.pl/f1b15

