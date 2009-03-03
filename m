Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZCCHnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZCCHnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZCCHnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:43:05 -0500
Received: from mail.lang.hm ([64.81.33.126]:40408 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZCCHnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:43:04 -0500
Date: Mon, 2 Mar 2009 23:42:45 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus'
 tree"
In-Reply-To: <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903022340060.14744@asgard.lang.hm>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>  <49ACC6B0.409@garzik.org>  <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>  <20090303072637.GB4440@kroah.com> <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, Luis R. Rodriguez wrote:

> On Mon, Mar 2, 2009 at 11:26 PM, Greg KH <greg@kroah.com> wrote:
>> - Show quoted text -
>> On Mon, Mar 02, 2009 at 10:44:40PM -0800, Luis R. Rodriguez wrote:
>>> On Mon, Mar 2, 2009 at 9:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>> Luis R. Rodriguez wrote:
>>>>>
>>>>> While extending the documentation for submitting Linux wireless bug
>>>>> reports [1] we note the stable series policy on patches -- that of
>>>>> having an equivalent fix already in Linus' tree. I find this
>>>>> documented in Documentation/stable_kernel_rules.txt but I'm curious if
>>>>> there is any other resource which documents this or elaborates on this
>>>>> a bit more. I often tell people about this rule or push _really_ hard
>>>>> on testing "upstream" but some people tend to not understand. I think
>>>>> that elaborating a little on this can help and will hopefully create
>>>>> more awareness around the importance of trees like Stephen's
>>>>> linux-next tree.
>>>>
>>>> Just have people google for GregKH's copious messages, telling people a fix
>>>> needs to be upstream before it goes into -stable.
>>>>
>>>> Typically you make things easy by emailing stable@kernel.org with a commit
>>>> id.
>>>>
>>>> There are only two exceptions:
>>>> * fix is upstream, but needs to be modified for -stable
>>>> * fix is not needed at all in upstream, but -stable still needs it
>>>
>>> This certainly helps, I'm also looking for good arguments to support
>>> the reasoning behind the policy so that not only will people follow
>>> this to help development but _understand_ it and so that they can
>>> themselves promote things like linux-next and realize why its so
>>> important. Mind you -- upstream for us in wireless for example is not
>>> Linus its John's tree so what we promote is not to get the fix first
>>> into Linus' tree but first into John's tree. Which is obvious to
>>> developers but perhaps not to others.
>>
>> Who are these "people" that you are trying to convince?
>
> OK small silly example is convincing distributions it may be a good
> idea to carry linux-next kernel packages as options to users to
> hopefully down the road reduce the delta between what they carry and
> what is actually upstream.

linux-next is a testing tree for developers, it changes day to day, 
doesn't contain all relavent changes, and is definantly _not_ something 
that distros should be pushing to users.

kernel.org kernels (and _possibly_ rc's) would have value (I'm glad to see 
Ubuntu making this move), but linux-next is not something that should be 
pushed out.

>> If they aren't
>> developers, why would any "others" care about our development
>> proceedures?
>
> Right -- in this case above "others" could be developers but could
> also be distribution guys. Essentially I was looking for arguments to
> push and show why linux-next is the next best thing since sliced bread
> for all those nasty deltas.
>
> Which OK -- maybe they can never disappear (?) but hopefully it can at
> least be reduced in size over time.
>
>> Heck, very few developers even read the Documentation files, I'd never
>> expect an "other" to do that :)
>
> Heh.. Maybe I expect too much of people and things.

I think you are misunderstanding linux-next and how it relates to users 
and distros.

David Lang
