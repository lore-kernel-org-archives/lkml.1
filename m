Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYAVURU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYAVURU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYAVURN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:17:13 -0500
Received: from main.gmane.org ([80.91.229.2]:35393 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYAVURM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:17:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Massive IDE problems. Who leaves data here?
Date: Tue, 22 Jan 2008 21:24:54 +0100
Message-ID: <fn5ivo$ck2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4bcfe.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.11) Gecko/20071129 SeaMonkey/1.1.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

anything started with a try to burn Slackware 12.0 from the original DVD 
to an new medium with different boot settings. I always got corrupted 
results and didn't know why.

So I started with an "md5sum -c CHECKSUMS.md5" directly on the original 
media. This resulted in "anything OK".

Now I copied the whole DVD to my hard drive and created an ISO from it. 
I mounted the ISO locally and my md5sum now results in 5 corrupted files.

--> A Bug in mkisofs?

No, unfortunately not, as a md5sum on the copy, I have created from the 
original DVD by using "cp -vr" is corrupted, too!

So md5sum on the original DVD is OK, but after copying to my hard drive, 
several files are corrupted.

I'm using kernel 2.6.21.5. Distribution is Slackware 12.0
All my "partitions" are LVs in LVM2

I also updated the kernel to 2.6.23.12 to test with this one, but I 
still get corrupted files.

Is this a LVM bug? Do I already have a corrupted LVM filesystem? How to 
check/fix it? Is this a known kernel bug? Which may be the reason for 
corrupted files?

I've created a backup of my important data to a second disc to a "real 
ext2 partition" (without LVM), but this is connected to the same IDE 
controller and I don't even know if I may still trust my mainboard...

I also get those kernel messages via dmesg:

http://pastebin.org/16537

Thank you very much in advance for any help!

Yours

Manuel

