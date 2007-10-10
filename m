Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXJJFzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXJJFzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 01:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbXJJFze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 01:55:34 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57765 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXJJFzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 01:55:33 -0400
Date: Tue, 09 Oct 2007 23:55:21 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Nvidia SATA - Seagate SATA Drives
In-reply-to: <fa.d5rGdIs30c4F+oG0m3Si2DyLz24@ifi.uio.no>
To: Jim Gifford <maillist@jg555.com>
Cc: Kernel <linux-kernel@vger.kernel.org>
Message-id: <470C6949.5050806@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.d5rGdIs30c4F+oG0m3Si2DyLz24@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Gifford wrote:
> Here's the situation. I have a MSI KN8Neo-f motherboard with a Seagate 
> Barracuda 250 GB SATA drive. I have replaced this drive three times in 
> the last two weeks due to it failing. Now the only thing in common is 
> the use of a 2.6.22.9 kernel I built from scratch, before that I was 
> using 2.6.19 kernel but working on doing some upgrades for the CLFS 
> project and tried a 2.6.22.9.  I will explain the situation and 
> including the links I used for fix the issues.
> 
> It boots up and instantly has a problem detecting so I have to add 
> irqpoll to my bootup line. {Reference 
> http://my.opera.com/snowburn/blog/index.dml/tag/failed%20to%20set%20xfermode} 
> Then I get the adma issue, so I add sata_nv.adma=0 to my bootup 
> line.{Reference 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/1424.html}
> 
> Now after a few times of booting the drive completely fails. So is the 
> nv_sata drive the cause?? Based on what I have done yes, and the reason 
> I can say that is because I took another one of those drives and the 
> same computer loaded Windows(forgive me for using this word!!!) on it 
> and it worked perfectly.

You'll have to be more specific about "completely fails".. Also, it 
would be useful to get the dmesg output from dmesg directly and not from 
syslog, as the entries posted under the second link you gave were 
missing some critical information (it seems that syslog can do this in 
some cases..) In particular the line showing what command failed would 
be useful.

Using "irqpoll" is not a very good workaround, it really is just a 
band-aid to get things working. Often this indicates motherboard IRQ 
routing issues. You may want to make sure you have the latest BIOS 
installed for the board.

> 
> One other issue that showed up was the drive does not recognize the 
> drive when it's in the 3gb transfer mode, I have to jumper it to 1.5gb 
> mode.
> 
> Here's a link to the drive model:   
> http://www.seagate.com/ww/v/index.jsp?vgnextoid=a62099f4fa74c010VgnVCM100000dd04090aRCRD&locale=en-US 
> 
> Here's a link to my motherboard: 
> http://www.msicomputer.com/product/p_spec.asp?model=K8N_Neo4-F&class=mb
> It has 2GB of Memory and a Nvidia PCI-E Graphics Adapter
> 
> I will work with any member of the lkml team to help isolate the issue, 
> the only issue is that when it locks up everything has to be written 
> down or photographed.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

