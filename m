Return-Path: <linux-kernel-owner+w=401wt.eu-S1161712AbXEAK2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161712AbXEAK2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161709AbXEAK2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:28:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:10853 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161686AbXEAK2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jzfL1ef0lVdttHDpPLxLLXTs6q/OD5yt0rs62pZwTSzm8qnpDNQPdwcQucivugfWXHVmiuXoFM9ErnG53ldwXpyrOefBuBPHLrigf1+O2DOz3gGGIn6dEgLX5gGANjwdMRtmDD4Wb330X+fzXRdNCwC7ivtzdhQ3yXXlc2G+BQc=
Message-ID: <463715E8.1060903@googlemail.com>
Date: Tue, 01 May 2007 12:26:48 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084623.GB14364@infradead.org> <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain> <20070501094400.GX943@1wt.eu>
In-Reply-To: <20070501094400.GX943@1wt.eu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, May 01, 2007 at 05:16:13AM -0400, Robert P. J. Day wrote:
>   
>> On Tue, 1 May 2007, Christoph Hellwig wrote:
>>
>>     
>>>>  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
>>>>         
>>> ...
>>>
>>>       
>>>> Dominik is busy.  Will probably re-review and send these direct to Linus.
>>>>         
>>> The patch above is the removal of cardmgr support.  While I'd love
>>> to see this cruft gone it definitively needs maintainer judgement on
>>> whether they time has come that no one relies on cardmgr anymore.
>>>       
>> since i was the one who submitted the original patch to remove that
>> stuff, let me make an observation.
>>
>> when i submitted a patch to remove, for instance, the traffic shaper
>> since it's clearly obsolete, i was told -- in no uncertain terms --
>> that that couldn't be done since there had been no warning about its
>> impending removal.
>>
>> fair enough, i can accept that.
>>
>> on the other hand, the features removal file contains the following:
>>
>> ...
>> What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
>> When:   November 2005
>> ...
>>
>> in other words, the PCMCIA ioctl feature *has* been listed as obsolete
>> for quite some time, and is already a *year and a half* overdue for
>> removal.
>>
>> in short, it's annoying to take the position that stuff can't be
>> deleted without warning, then turn around and be reluctant to remove
>> stuff for which *more than ample warning* has already been given.
>> doing that just makes a joke of the features removal file, and makes
>> you wonder what its purpose is in the first place.
>>
>> a little consistency would be nice here, don't you think?
>>     
>
> No, it just shows how useless this file is. What is needed is a big
> warning during usage, not a file that nobody reads. Facts are :
>
>   - 90% of people here do not even know that this file exists
>   - 80% of the people who know about it do not consult it on a regular basis
>   - 80% of those who consult it on a regular basis are not concerned
>   - 75% of statistics are invented
>
> => only 20% of 20% of 10% of those who read LKML know that one feature
>    they are concerned about will soon be removed = 0.4% of LKML readers.
>
> If you put a warning in kernel messages (as I've seen for a long time
> about tcpdump using obsolete AF_PACKET), close to 100% of the users
> of the obsolete code who are likely to change their kernels will notice
> it.
>
>   

Hmm ? There is already a fat warning in dmesg for a long time now.


snip

...

pcmcia: Detected deprecated PCMCIA ioctl usage from process: discover.
pcmcia: This interface will soon be removed from the kernel; please 
expect breakage unless you upgrade to new tools.
pcmcia: see 
http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.

...


> I'm sorry for your patch which may get delayed a lot. You would spend
> fewer time stuffing warnings in areas affected by scheduled removal.
>
> BTW, I'm not even against the end of cardmgr support, it's just that
> I don't know what the alternative is, and I suspect that many users
> do not either. A big warning would have brought them to google who
> would have provided them with suggestions for alternatives.
>
> Willy
>
>
>   

Regards,

Gabriel

