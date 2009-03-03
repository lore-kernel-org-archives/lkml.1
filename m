Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbZCCH5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbZCCH5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZCCH50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:57:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:14890 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZCCH5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:57:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mU5eMAUEjFrtxq1qLZ7BNj8WlGBAy3O1sO9rEHNr84TwDaXyK4hsrM19S9BrR8iAoi
         qK/PUPyKyuZRlJv0blMwIr/3vNrVjbfO2a7Uhxb1TgDu9IJRZtGnrGbfR3NLh1sTStb2
         VZbG4yD1LzcqHbjVwYaCeM6QAxhxSOo5Labx4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0903022340060.14744@asgard.lang.hm>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
	 <49ACC6B0.409@garzik.org>
	 <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
	 <20090303072637.GB4440@kroah.com>
	 <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
	 <alpine.DEB.1.10.0903022340060.14744@asgard.lang.hm>
Date: Mon, 2 Mar 2009 23:57:23 -0800
Message-ID: <43e72e890903022357p7594cf98gd7c1061a78f8828a@mail.gmail.com>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 11:42 PM,  <david@lang.hm> wrote:
> - Show quoted text -
> On Mon, 2 Mar 2009, Luis R. Rodriguez wrote:
>
>> On Mon, Mar 2, 2009 at 11:26 PM, Greg KH <greg@kroah.com> wrote:
>>>
>>> - Show quoted text -
>>> On Mon, Mar 02, 2009 at 10:44:40PM -0800, Luis R. Rodriguez wrote:
>>>>
>>>> On Mon, Mar 2, 2009 at 9:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>>>
>>>>> Luis R. Rodriguez wrote:
>>>>>>
>>>>>> While extending the documentation for submitting Linux wireless bug
>>>>>> reports [1] we note the stable series policy on patches -- that of
>>>>>> having an equivalent fix already in Linus' tree. I find this
>>>>>> documented in Documentation/stable_kernel_rules.txt but I'm curious if
>>>>>> there is any other resource which documents this or elaborates on this
>>>>>> a bit more. I often tell people about this rule or push _really_ hard
>>>>>> on testing "upstream" but some people tend to not understand. I think
>>>>>> that elaborating a little on this can help and will hopefully create
>>>>>> more awareness around the importance of trees like Stephen's
>>>>>> linux-next tree.
>>>>>
>>>>> Just have people google for GregKH's copious messages, telling people a
>>>>> fix
>>>>> needs to be upstream before it goes into -stable.
>>>>>
>>>>> Typically you make things easy by emailing stable@kernel.org with a
>>>>> commit
>>>>> id.
>>>>>
>>>>> There are only two exceptions:
>>>>> * fix is upstream, but needs to be modified for -stable
>>>>> * fix is not needed at all in upstream, but -stable still needs it
>>>>
>>>> This certainly helps, I'm also looking for good arguments to support
>>>> the reasoning behind the policy so that not only will people follow
>>>> this to help development but _understand_ it and so that they can
>>>> themselves promote things like linux-next and realize why its so
>>>> important. Mind you -- upstream for us in wireless for example is not
>>>> Linus its John's tree so what we promote is not to get the fix first
>>>> into Linus' tree but first into John's tree. Which is obvious to
>>>> developers but perhaps not to others.
>>>
>>> Who are these "people" that you are trying to convince?
>>
>> OK small silly example is convincing distributions it may be a good
>> idea to carry linux-next kernel packages as options to users to
>> hopefully down the road reduce the delta between what they carry and
>> what is actually upstream.
>
> linux-next is a testing tree for developers, it changes day to day, doesn't
> contain all relavent changes, and is definantly _not_ something that distros
> should be pushing to users.

Why not? Just as people may want to get bleeding edge wireless I don't
see why a user may not want to simply get bleeding edge wireless and
bleeding edge audio, and video. The latest RC series helps but lets
face it there are also a lot of good stuff queued for the -next
releases as well. The way I'm seeing this is if a user has no support
for a device on their system it should look something like this:

Distribution kernel -->
  Distribution next stable kernel release (2.6.27 --> 2.6.28) -->
    Distribution RC kernel (if one is available) | kernel.org RC kernel -->
      Development tree kernel for a specific device -->
        Staging

If the have multiple devices which are not yet supported by the latest
RC kernel but on -next then you have little options but I think a
concrete one should exist and it does.

>> Heh.. Maybe I expect too much of people and things.
>
> I think you are misunderstanding linux-next and how it relates to users and
> distros.

Probably if the above is not something a user may not actually want to test.

  Luis
