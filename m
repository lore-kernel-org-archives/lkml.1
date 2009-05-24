Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZEXR7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZEXR7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 13:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZEXR7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 13:59:25 -0400
Received: from h155.mvista.com ([63.81.120.155]:14726 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752856AbZEXR7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 13:59:24 -0400
Message-ID: <4A198B37.1070100@ru.mvista.com>
Date: Sun, 24 May 2009 22:00:23 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/ide/ide-core: Unsplit constant strings for
 pr_<level> and dev_<level>
References: <cover.1243062772.git.joe@perches.com>	 <57f9dd5c33bcdd863793a3ee95ab050e8456bab4.1243062772.git.joe@perches.com>	 <4A19399B.8060207@ru.mvista.com> <1243183596.3560.19.camel@Joe-Laptop.home>
In-Reply-To: <1243183596.3560.19.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Joe Perches wrote:

>>>-		dev_err(&drive->gendev, "%s: packet size (0x%02x) is not 12 "
>>>-			"bytes\n", s, packet_size);
>>>+		dev_err(&drive->gendev,
>>>+			"%s: packet size (0x%02x) is not 12 bytes\n",

>>   When the message is broken by the format specifier, turning it into 
>>one liner can hardly help seraching...

> grep "is not 12 bytes"

    Yes, carrying "is not 12 " to that would have made sense.

>>   Oh noes, the indentation...

> trade-offs...

>>>+	"(IO,CoD != (0,1) while issuing a packet command, retrying\n");

>>   Sigh...

> You seem to sigh a lot.  ;)

    I'm not sure you'll like "ugh" better.

>>>+		"unexpected interrupt, status=0x%02x, count=%ld\n",

>>   Hardly won anything...
>>
>>>+ "%s side 80-wire cable detection failed, limiting max speed to UDMA33\n",
>>
>>    Will you really use the full message to serch here?
>>
>>>+		 "probing with STATUS(0x%02x) instead of ALTSTATUS(0x%02x)\n",
>>
>>   Same comment about the line broken by the format specifiers. This 
>>wins absolutely nothing.

> grep "STATUS.*ALTSTATUS"

    Hm, I didn't think about wildcards. Yet I find search for "probing with 
STATUS" more probable.

>>>+		"no response (status = 0x%02x), resetting drive\n",
>>
>>   And again...

> grep "response.*resetting"

    I'd grep for "no response (status =" in this case.

> cheers, Joe

MBR, Sergei
