Return-Path: <linux-kernel-owner+w=401wt.eu-S2992640AbXCXAPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992640AbXCXAPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992642AbXCXAPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:15:32 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:51518 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992640AbXCXAPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:15:31 -0400
Date: Sat, 24 Mar 2007 01:14:35 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc regression in mptbase
In-Reply-To: <46045D8B.8020201@redhat.com>
Message-ID: <Pine.LNX.4.61.0703240111380.10028@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703232322030.10028@yvahk01.tjqt.qr>
 <46045D8B.8020201@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 23 2007 19:06, Chuck Ebbert wrote:
>Jan Engelhardt wrote:
>> Hello world,
>> 
>> 
>> in at least 2.6.21-rc4, one or more of the mptscsi scsi modules is 
>> broken with respect to not detecting any harddisk (VMware provides that 
>> virtual LSI MPT controller), which means no working system.
>> No problems in 2.6.20.2.
>> 
>> I will be trying 2.6.21-rc1 shortly.

Note: The harddisk is detected [or not] when mptspi.ko is loaded, but the
message that something has been detected is printed by mptbase, so I do not
exactly know which one is at fault.

>Also try 2.6.20.4. There are reports of this problem there as well.

Ok, will do that.

2.6.21-rc1 = broken
2.6.20.4   = works


Jan
-- 
