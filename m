Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0BCP2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:28:44 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:58451 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0BCP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:28:42 -0500
Message-ID: <4B699625.5040808@davidnewall.com>
Date: Thu, 04 Feb 2010 01:58:37 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Derek Atkins <warlord@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: Re-enabling non-GPL driver access to disk partition information
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org> <20100129220601.GA19687@kroah.com> <4B63AF4C.9040003@davidnewall.com> <20100203021049.GA17576@kroah.com>
In-Reply-To: <20100203021049.GA17576@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Jan 30, 2010 at 02:32:20PM +1030, David Newall wrote:
>   
>> Greg KH wrote:
>>     
>>> On Fri, Jan 29, 2010 at 09:15:09AM -0500, Derek Atkins wrote:
>>>   
>>>       
>>>> -EXPORT_SYMBOL_GPL(put_device);
>>>> +EXPORT_SYMBOL(put_device);
>>>>     
>>>>         
>>> No, sorry, [...] I can not, and will not, make this change.
>>>   
>>>       
>> Derek,
>>
>> Consider writing a GPL wrapper module.
>>     
>
> Ah, the old "GPL condom" try.  Sorry, but this has been tried many times
> in the past, and have been shut down every time.  See the Samba history
> of this for lots of details as to why this does not work.


Samba vs The Money merely shows that The Money failed to put up a 
sufficient defence. Good result for FOSS, but I recommend against you 
betting your home on it.

Anyway, I was thinking of something a little more substantial that what 
you perhaps read into my suggestion. There's usually a substantial gap 
between the pure needs of a driver and the facilities offered by an 
operating system. In the case in question, for example, the need is to 
count the number of partitions, and the facility offered is get_device, 
or something. A tiny GPL module that calls get_device and returns a 
count sounds eminently defensible.

In addition--and please keep in mind that I'm unfamiliar with the 
internals of the kernel--it seems to me there's an obvious similarity 
with USL vs BSD, alleging copyright for verbatim copying of macro 
constants, amongst other things. A lesson that learned then was that you 
can't prevent someone from using provided facilities necessary for use 
of the operating system. I don't know what put_device does, but I know 
what it sounds like; it sounds like it's something that you have to use, 
and so one can use it, even in proprietary code. I imagine this idea 
will irritate those who put in the hard yards, but FOSS has to play by 
the same rules as the monied end of town. You might want to think about 
this carefully, because if it's taken all the way through court and the 
GPL-only claim rejected, there may well be a run-on effect on all of the 
symbols marked GPL-only. Those who want to thwart proprietary kernel 
modules may find it prudent to generously give up this symbol rather 
than risking the lot.
