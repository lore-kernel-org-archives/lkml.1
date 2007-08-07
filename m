Return-Path: <linux-kernel-owner+w=401wt.eu-S933435AbXHFXt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbXHFXt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbXHFXtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:49:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:52296 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932623AbXHFXtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:49:15 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/H9M5XbOjHsBovJbuYALfSWcmabugXxVmg04ecqG
	6A3wB8Ar/Mzr5O
Message-ID: <46B7C18E.1050008@gmx.net>
Date: Tue, 07 Aug 2007 02:49:18 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net> <46B60FB7.8030301@interia.pl> <200708052142.14630.jimis@gmx.net> <46B748DE.1060108@interia.pl> <46B773F6.7060603@gmx.net> <46B79CDE.2030709@interia.pl>
In-Reply-To: <46B79CDE.2030709@interia.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Bilski wrote:
>> Hello Rafal,
> Hello,
>> However I find it quite possible to have reached the throughput limit 
>> because of software (driver) problems. I have done various testing 
>> (mostly "hdparm -tT" with exactly the same PC and disks since about 
>> kernel 2.6.8 (maybe even earlier). I remember with certainty that read 
>> throughput the early days was about 50MB/s for each of the big disks, 
>> and combined with RAID 0 I got ~75MB/s. Those figures have been 
>> dropping gradually with each new kernel release and the situation 
>> today, with 2.6.22, is that hdparm gives maximum throughput 20MB/s for 
>> each disk, and for RAID 0 too!
> Just tested (plain curiosity).
> via82cxxx average result @533MHz:
> /dev/hda:
> Timing cached reads:   232 MB in  2.00 seconds = 115.93 MB/sec
> Timing buffered disk reads:   64 MB in  3.12 seconds =  20.54 MB/sec
> pata_via average result @533MHz:
> /dev/sda:
> Timing cached reads:   234 MB in  2.01 seconds = 116.27 MB/sec
> Timing buffered disk reads:   82 MB in  3.05 seconds =  26.92 MB/sec

Interesting! I haven't tried libata myself on that system, I only have 
remote access to it so I'm a bit afraid...

Rafal, I hope that system you run hdparm on isn't the archlinux one! Is 
it easy to load an old kernel (even two years old) and do the same test? 
If it is, please let me know of the results.


Thanks in advance,
Dimitris


