Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXENUBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXENUBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXENUBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:01:10 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37178 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbXENUBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:01:09 -0400
Date: Mon, 14 May 2007 22:00:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
In-Reply-To: <46489EF1.2020509@gmx.de>
Message-ID: <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 1.3 points, 6.0 required
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 19:40, Lars K.W. Gohlke wrote:
>> 
>> hallo,
>> 
>> after searching the mailing list and searching the web, I still don't
>> know how to access correctly the serial port (in user space known as
>> /dev/ttyS01)

http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad

>> This thread ends before the answer was given and the site redirecting
>> too is restructured:
>> http://marc.info/?l=kernelnewbies&m=98314502419089&w=2
>> 
>> would somebody be so kind to give me an example:
>> 
>> with this behaviour:
>> 
>> 1. read from port
>> 2. output via printk()
>> 3. write to port

inb/inw/inl, printk, outb/outw/outl.

>> I've created already my own char-dev and used it in user-space.
>> However I don't know really how to get information from kernel-code to
>> solve this.

http://lwn.net/Kernel/LDD3/

> would be somebody so polite and give me at least a hint?
> Where to search concretely, or small template.

It's been 4 hours and 40 minutes, and you already expect an answer?
I don't remember you having paid anyone...


	Jan
-- 
