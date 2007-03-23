Return-Path: <linux-kernel-owner+w=401wt.eu-S934263AbXCWBZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263AbXCWBZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbXCWBZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:25:11 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:57937 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265AbXCWBZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:25:10 -0400
Date: Fri, 23 Mar 2007 02:24:46 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sysfs q [was: sysfs ugly timer interface]
In-Reply-To: <20070322152842.GA6054@kroah.com>
Message-ID: <Pine.LNX.4.61.0703230221350.9555@yvahk01.tjqt.qr>
References: <200703161230.03712.maximlevitsky@gmail.com> <200703161919.44458.lenb@kernel.org>
 <200703180100.01889.maximlevitsky@gmail.com> <20070320115403.GA3983@ucw.cz>
 <20070322152842.GA6054@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 22 2007 08:28, Greg KH wrote:
>> 
>> > root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered
>> > lapic                F:0007 M:3(periodic) C: 1
>> > hpet                 F:0003 M:1(shutdown) C: 0
>> > lapic                F:0007 M:3(periodic) C: 0
>> > root@MAIN:/home/maxim#   
>> 
>> Now... this file needs to die, before 2.6.21 is released. It tries to
>> bring /proc-like parsing nightmare to sysfs. Kill it before it becomes
>> part of stable ABI!
>
>Eeek!

Question regarding sysfs files: How would you do something like
/proc/net/nf_conntrack with sysfs? Have directories named like 0000, 
0001, 0002, ..?


Jan
-- 
