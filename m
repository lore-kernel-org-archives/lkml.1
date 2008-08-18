Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbYHRKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYHRKJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYHRKJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:09:28 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:41210 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYHRKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:09:28 -0400
Message-ID: <48A94A55.2080309@aitel.hist.no>
Date: Mon, 18 Aug 2008 12:09:25 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "Press, Jonathan" <Jonathan.Press@ca.com>
CC: Theodore Tso <tytso@mit.edu>, douglas.leeder@sophos.com,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Peter Zijlstra <peterz@infradead.org>, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
References: <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <20080815131820.053BF31679D@pmx1.sophos.com> <20080815170441.GA22395@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4C14@USILMS12.ca.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4C14@USILMS12.ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Press, Jonathan wrote:
>> -----Original Message-----
>> From: Theodore Tso [mailto:tytso@mit.edu]
>> Sent: Friday, August 15, 2008 1:05 PM
>> To: douglas.leeder@sophos.com
>> Cc: Press, Jonathan; alan@lxorguk.ukuu.org.uk; andi@firstfloor.org;
>>     
> Arjan van de
>   
>> Ven; hch@infradead.org; Helge Hafting; linux-kernel@vger.kernel.org;
>>     
> malware-
>   
>> list@lists.printk.net; Peter Zijlstra; viro@ZenIV.linux.org.uk
>> Subject: Re: [malware-list] TALPA - a threat model? well sorta.
>>
>>     
>>> Not to mention removable media - it might be old hat, but
>>>       
> infected/malware
>   
>>> files can come in on floppies, CDs or USB flash discs careless left
>>>       
> on the
>   
>>> pavement outside an office.
>>>       
>> That's not a problem given the scanning model proposed by Eric; when
>> you insert removable media, it will get scanned when it is first
>> accessed.
>>     
>
> That is exactly the idea.  However, the context of this particular
> thread was the following statement by Helge Hafting:
>
> 	It seems to me that this "scan on file open" business is the
> wrong 
> 	way to do things - because it reduces performance.
>
> 	If you scan on file open, then your security sw is too late and 
> 	getting in the way.
>
>  
> We were just pointing out that this is not a good argument in practical
> terms AGAINST scanning on open.  In fact, your reply completely
> reinforces that point.
>   
Scanning on open should be a last resort. Scan in advance when you can.
Of course, removable media cannot be scanned until it is inserted and 
mounted,
that is obvious. The scanning can start as soon as the filesystem is 
mounted though,
there is no reason to wait until users try to access something.

A CD inserted into a CD-server may not necessarily be needed immediately, so
scanning in advance will help here too. The user inserting a CD in a home
computer may start to use stuff right away, or perhaps he spends
some time reading the docs before a complicated install. Sill room for some
scanning in advance, which also may end up with the nice effect of 
caching the CD.

Helge Hafting



