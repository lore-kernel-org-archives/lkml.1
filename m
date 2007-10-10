Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbXJJD5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbXJJD5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 23:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXJJD5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 23:57:31 -0400
Received: from rrcs-64-183-102-10.west.biz.rr.com ([64.183.102.10]:34449 "EHLO
	jg555.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751147AbXJJD5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 23:57:30 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 23:57:30 EDT
Message-ID: <470C4C6A.8090109@jg555.com>
Date: Tue, 09 Oct 2007 20:52:10 -0700
From: Jim Gifford <maillist@jg555.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Kernel <linux-kernel@vger.kernel.org>
Subject: Nvidia SATA - Seagate SATA Drives
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the situation. I have a MSI KN8Neo-f motherboard with a Seagate 
Barracuda 250 GB SATA drive. I have replaced this drive three times in 
the last two weeks due to it failing. Now the only thing in common is 
the use of a 2.6.22.9 kernel I built from scratch, before that I was 
using 2.6.19 kernel but working on doing some upgrades for the CLFS 
project and tried a 2.6.22.9.  I will explain the situation and 
including the links I used for fix the issues.

It boots up and instantly has a problem detecting so I have to add 
irqpoll to my bootup line. {Reference 
http://my.opera.com/snowburn/blog/index.dml/tag/failed%20to%20set%20xfermode} 
Then I get the adma issue, so I add sata_nv.adma=0 to my bootup 
line.{Reference 
http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/1424.html}

Now after a few times of booting the drive completely fails. So is the 
nv_sata drive the cause?? Based on what I have done yes, and the reason 
I can say that is because I took another one of those drives and the 
same computer loaded Windows(forgive me for using this word!!!) on it 
and it worked perfectly.

One other issue that showed up was the drive does not recognize the 
drive when it's in the 3gb transfer mode, I have to jumper it to 1.5gb mode.

Here's a link to the drive model:   
http://www.seagate.com/ww/v/index.jsp?vgnextoid=a62099f4fa74c010VgnVCM100000dd04090aRCRD&locale=en-US
Here's a link to my motherboard: 
http://www.msicomputer.com/product/p_spec.asp?model=K8N_Neo4-F&class=mb
It has 2GB of Memory and a Nvidia PCI-E Graphics Adapter

I will work with any member of the lkml team to help isolate the issue, 
the only issue is that when it locks up everything has to be written 
down or photographed.

Jim Gifford - CLFS Developer
http://www.cross-lfs.org

