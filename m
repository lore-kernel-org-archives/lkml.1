Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYAVUZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYAVUZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYAVUZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:25:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbYAVUZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:25:31 -0500
Message-ID: <47965138.8060603@garzik.org>
Date: Tue, 22 Jan 2008 15:25:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Massive IDE problems. Who leaves data here?
References: <fn5ivo$ck2$1@ger.gmane.org>
In-Reply-To: <fn5ivo$ck2$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Reimer wrote:
> Hello,
> 
> anything started with a try to burn Slackware 12.0 from the original DVD 
> to an new medium with different boot settings. I always got corrupted 
> results and didn't know why.
> 
> So I started with an "md5sum -c CHECKSUMS.md5" directly on the original 
> media. This resulted in "anything OK".
> 
> Now I copied the whole DVD to my hard drive and created an ISO from it. 
> I mounted the ISO locally and my md5sum now results in 5 corrupted files.
> 
> --> A Bug in mkisofs?
> 
> No, unfortunately not, as a md5sum on the copy, I have created from the 
> original DVD by using "cp -vr" is corrupted, too!
> 
> So md5sum on the original DVD is OK, but after copying to my hard drive, 
> several files are corrupted.
> 
> I'm using kernel 2.6.21.5. Distribution is Slackware 12.0
> All my "partitions" are LVs in LVM2
> 
> I also updated the kernel to 2.6.23.12 to test with this one, but I 
> still get corrupted files.
> 
> Is this a LVM bug? Do I already have a corrupted LVM filesystem? How to 
> check/fix it? Is this a known kernel bug? Which may be the reason for 
> corrupted files?
> 
> I've created a backup of my important data to a second disc to a "real 
> ext2 partition" (without LVM), but this is connected to the same IDE 
> controller and I don't even know if I may still trust my mainboard...
> 
> I also get those kernel messages via dmesg:
> 
> http://pastebin.org/16537

If your IDE interface is complaining about BadCRC errors, then it's 
complaining about hardware problems (bad cable, etc.)

	Jeff



