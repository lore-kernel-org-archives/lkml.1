Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZBXT3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZBXT3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZBXT3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:29:21 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:56016 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZBXT3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:29:21 -0500
Message-ID: <49A44A86.2030409@nortel.com>
Date: Tue, 24 Feb 2009 13:29:10 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RT scheduling and a way to make a process hang, unkillable
References: <20090216120213.GB3925@linux.vnet.ibm.com>	 <1234787082.30178.3.camel@laptop>	 <20090216131440.GC3925@linux.vnet.ibm.com>	 <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org>	 <20090217050033.GA10409@linux.vnet.ibm.com>	 <20090217101542.GB15989@linux.vnet.ibm.com>	 <1234869339.4744.77.camel@laptop>	 <20090223114541.GD31277@linux.vnet.ibm.com>	 <1235390396.4645.87.camel@laptop>	 <20090224091849.GA18693@linux.vnet.ibm.com>	 <874oyj4yiz.fsf@basil.nowhere.org> <1235493365.4645.2061.camel@laptop>
In-Reply-To: <1235493365.4645.2061.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2009 19:29:13.0892 (UTC) FILETIME=[2CF02640:01C996B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-02-24 at 16:58 +0100, Andi Kleen wrote:
>> Dhaval Giani <dhaval@linux.vnet.ibm.com> writes:
>>>  		new->euid = euid;
>>> Index: linux-2.6/include/asm-generic/errno.h
>>> ===================================================================
>>> --- linux-2.6.orig/include/asm-generic/errno.h
>>> +++ linux-2.6/include/asm-generic/errno.h
>>> @@ -106,4 +106,6 @@
>>>  #define	EOWNERDEAD	130	/* Owner died */
>>>  #define	ENOTRECOVERABLE	131	/* State not recoverable */
>>>  
>>> +#define ENOTIME		132	/* No time available to run process */
>> It's normally not a good idea to add new errnos, because old glibc's
>> strerror()s won't know about it.
>>
>> There are also so many around that you surely will find an existing
>> one which sounds appropiate.
> 
> Feel free to suggest one, I've read over all these error thingies
> several times and non really stood out.
> 
> We tried ENOSPC, but people thought that weird too.

What about EDQUOT, as in "the user you're trying to become has no quota".

Chris
