Return-Path: <linux-kernel-owner+w=401wt.eu-S1764784AbXHFWNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764784AbXHFWNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbXHFWM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:12:59 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:41066 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751664AbXHFWM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:12:58 -0400
Message-ID: <46B79CDE.2030709@interia.pl>
Date: Tue, 07 Aug 2007 00:12:46 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net> <46B60FB7.8030301@interia.pl> <200708052142.14630.jimis@gmx.net> <46B748DE.1060108@interia.pl> <46B773F6.7060603@gmx.net>
In-Reply-To: <46B773F6.7060603@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: cc8d6acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello Rafal,
Hello, 
> However I find it quite possible to have reached the throughput limit 
> because of software (driver) problems. I have done various testing 
> (mostly "hdparm -tT" with exactly the same PC and disks since about 
> kernel 2.6.8 (maybe even earlier). I remember with certainty that read 
> throughput the early days was about 50MB/s for each of the big disks, 
> and combined with RAID 0 I got ~75MB/s. Those figures have been dropping 
> gradually with each new kernel release and the situation today, with 
> 2.6.22, is that hdparm gives maximum throughput 20MB/s for each disk, 
> and for RAID 0 too!
Just tested (plain curiosity).
via82cxxx average result @533MHz:
/dev/hda:
 Timing cached reads:   232 MB in  2.00 seconds = 115.93 MB/sec
 Timing buffered disk reads:   64 MB in  3.12 seconds =  20.54 MB/sec
pata_via average result @533MHz:
/dev/sda:
 Timing cached reads:   234 MB in  2.01 seconds = 116.27 MB/sec
 Timing buffered disk reads:   82 MB in  3.05 seconds =  26.92 MB/sec

Same 2.6.23-rc1-git11 kernel. 
Yes - constant 6MB/s difference (31%). Cool.
> Dimitris
Regards
Rafał

----------------------------------------------------------------------
Jestes sexy? Dodaj swoje fotki i daj sie ocenic na 
>>>http://link.interia.pl/f1b21

