Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbYBFVEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbYBFVEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbYBFVEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:04:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:50024 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbYBFVEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:04:40 -0500
Message-ID: <47AA203D.3010500@oracle.com>
Date: Wed, 06 Feb 2008 13:01:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>	 <1201815920-24669-2-git-send-email-ijc@hellion.org.uk>	 <1201815920-24669-3-git-send-email-ijc@hellion.org.uk>	 <47A24765.3070300@zytor.com>	 <1201856568.3804.8.camel@cthulhu.hellion.org.uk>	 <20080205170939.10085936.randy.dunlap@oracle.com> <1202331539.7333.9.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1202331539.7333.9.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Tue, 2008-02-05 at 17:09 -0800, Randy Dunlap wrote:
>> On Fri, 01 Feb 2008 09:02:48 +0000 Ian Campbell wrote:
>>>  
>>> +**** THE IMAGE CHECKSUM
>>> +
>>> +The CRC-32 is calculated over the entire file using an initial
>>> +remainder of 0xffffffff.  The checksum is appended to the file
>> Run-on sentences.
>> Use period (full stop) or semi-colon at end of above sentence.
>> If using a period, capitalize the next word.  Thanks.
>>
>>
>>> +therefore the CRC of the file up to the limit specified in the syssize
>>> +field of the header is always 0.
> 
> Thanks. I went with:
> 
> +The CRC-32 is calculated over the entire file using an initial
> +remainder of 0xffffffff.  The checksum is appended to the file;
> +therefore the CRC of the file up to the limit specified in the syssize
> +field of the header is always 0.

Fine, thanks.

-- 
~Randy
