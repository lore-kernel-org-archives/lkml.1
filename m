Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYCYOow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYCYOow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYCYOoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:44:38 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:21046 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbYCYOog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:44:36 -0400
Message-ID: <47E90CDA.600@emc.com>
Date: Tue, 25 Mar 2008 10:31:54 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH l <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org> <47E8FF58.8050209@rtr.ca>
In-Reply-To: <47E8FF58.8050209@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=0%, Reason='EMC_BODY_PROD_1+ -3, EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> On Mon, 24 Mar 2008, Mark Lord wrote:
>>> The return value uses "unsigned long",
>>> which on a 32-bit system limits drive offsets to 2TB.
>>
>> One relevant question is: does anybody seriously care about the 
>> combination of "32 bit" and "huge modern drives" any more?
>>
>> Sure, we can add a 64-bit version that ends up being used only on 
>> 32-bit systems, but quite frankly, I think the solution here is to 
>> just ignore the issue and see if anybody really even cares.
>>
>> Because quite frankly, the kind of people who buy modern 2TB drives 
>> generally don't then couple them to CPU's that are five+ years old.
> ..
> 
> Yeah.  Except Dell will undoubtedly have them in desktops
> within 2 years, and tons of people (myself included) still use
> 32-bit (K)Ubuntu on our systems, simply for the better binary 
> compatibility that it is perceived to give with things like
> browser plugins and stuff.

I think that there are many embedded applications (lots of them linux based)
which have large amounts of storage behind low power, low cost 32 bit CPU's.

Think of the home/small office NAS boxes that you can get from bestbuy or other 
big box stores. Those devices today have 4 S-ATA drives (each of which can be 
1TB in size).

Also, if you have a very low end box, it can still access really large storage
over iSCSI or a SAN which will present as a local, large device.

Over time, even these low end CPU's will migrate towards 64 bits, but we are not
there yet...

ric



