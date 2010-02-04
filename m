Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab0BDAaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:30:22 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:43813 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0BDAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:30:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Xhn0Z1KKywYQDCHeYg+MfTFu/KG8pIyQp3jJbBXuhxdXVoLHx71lvoXPhgu5XOjjeJ
         PzHfnPXWprRqgaaCs4j6Gbu5GVfQiwEYoTvS8WsQ4OHpDeRQRRWep6f3M7Kc5G7wqzeL
         I2P6LKvI4D7ML0+oFZJ4beF6waZqIinV+aX+g=
Message-ID: <4B6A151A.9080408@gmail.com>
Date: Wed, 03 Feb 2010 18:30:18 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Greg KH <greg@kroah.com>, Derek Atkins <warlord@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Re-enabling non-GPL driver access to disk partition information
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org> <20100129220601.GA19687@kroah.com> <4B63AF4C.9040003@davidnewall.com> <20100203021049.GA17576@kroah.com> <4B699625.5040808@davidnewall.com>
In-Reply-To: <4B699625.5040808@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 09:28 AM, David Newall wrote:
> Greg KH wrote:
>> On Sat, Jan 30, 2010 at 02:32:20PM +1030, David Newall wrote:
>>> Greg KH wrote:
>>>> On Fri, Jan 29, 2010 at 09:15:09AM -0500, Derek Atkins wrote:
>>>>> -EXPORT_SYMBOL_GPL(put_device);
>>>>> +EXPORT_SYMBOL(put_device);
>>>> No, sorry, [...] I can not, and will not, make this change.
>>> Derek,
>>>
>>> Consider writing a GPL wrapper module.
>>
>> Ah, the old "GPL condom" try. Sorry, but this has been tried many times
>> in the past, and have been shut down every time. See the Samba history
>> of this for lots of details as to why this does not work.
>
>
> Samba vs The Money merely shows that The Money failed to put up a
> sufficient defence. Good result for FOSS, but I recommend against you
> betting your home on it.
>
> Anyway, I was thinking of something a little more substantial that what
> you perhaps read into my suggestion. There's usually a substantial gap
> between the pure needs of a driver and the facilities offered by an
> operating system. In the case in question, for example, the need is to
> count the number of partitions, and the facility offered is get_device,
> or something. A tiny GPL module that calls get_device and returns a
> count sounds eminently defensible.
>
> In addition--and please keep in mind that I'm unfamiliar with the
> internals of the kernel--it seems to me there's an obvious similarity
> with USL vs BSD, alleging copyright for verbatim copying of macro
> constants, amongst other things. A lesson that learned then was that you
> can't prevent someone from using provided facilities necessary for use
> of the operating system. I don't know what put_device does, but I know
> what it sounds like; it sounds like it's something that you have to use,
> and so one can use it, even in proprietary code. I imagine this idea
> will irritate those who put in the hard yards, but FOSS has to play by
> the same rules as the monied end of town. You might want to think about
> this carefully, because if it's taken all the way through court and the
> GPL-only claim rejected, there may well be a run-on effect on all of the
> symbols marked GPL-only. Those who want to thwart proprietary kernel
> modules may find it prudent to generously give up this symbol rather
> than risking the lot.

The GPL flag on the symbols has no legal weight. What does have legal 
weight is whether whatever you're linking into the kernel can be 
considered a derivative work of the kernel or not. The intent of the 
EXPORT_SYMBOL_GPL flag is to warn that if you're using these symbols, 
then you're hooking into something sufficiently internal that you may be 
considered a derivative work. However, using symbols marked GPL in a 
non-GPL module doesn't necessarily mean you're violating the GPL, nor 
does not using them mean you're not. The only one that can give a 
definitive answer for any particular piece of code is likely a lawyer.
