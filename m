Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXE0SEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXE0SEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 14:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXE0SEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 14:04:33 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:44243 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbXE0SEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 14:04:32 -0400
Date: Sun, 27 May 2007 11:04:24 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2/2] [condingstyle] Add chapter on tests
In-reply-to: <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Message-id: <4659C828.80503@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
 <20070525172515.5138.13652.stgit@localhost.localdomain>
 <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 25 2007 10:25, Auke Kok wrote:
>> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>> index f518395..3635b38 100644
>> --- a/Documentation/CodingStyle
>> +++ b/Documentation/CodingStyle
>> @@ -393,7 +393,7 @@ int fun(int a)
>> 	int result = 0;
>> 	char *buffer = kmalloc(SIZE);
>>
>> -	if (buffer == NULL)
>> +	if (!buffer)
>> 		return -ENOMEM;
> 
> Please don't do this. With ==NULL/!=NULL, it is clear what
> <randomvariable> could be (integer or pointer) without needing
> to look it up. It also reads quite strange: "if not buffer".
> For bools ('adjectives' / 'is a'), it works, not so much for ptrs.
> Hence:
> 
>> +If you give your variables and pointers good names, there is never a need
>> +to compare the value stored in that variable to NULL or true/false, so
>> +omit all that and keep it short.
> 
>> +	ptr = s->next;
>> +	if (!ptr)
>> +		return;
> 
> Not agreed.

that piece is a copy of mm/slab.c, and all over the core components of the 
kernel (even fs/inode.c written by Linus). I strongly think that "== NULL" 
doesn't add anything and that well-written functions and well-named variables 
really do not need the extra fluff.

Auke
