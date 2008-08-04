Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYHDLSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYHDLSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYHDLSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:18:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:15932 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYHDLSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cfHaRKM1CgSnaWoR9scsqj8p9BPLr0Br8qyWjXhjmziIdJiwsbEGKmEFcKiqASxlDl
         N8pqeijT+Pp4K4OCYTXmzY77MXmaEwlcOa99o6XVQKmLiKid/Acu6Jy26RzCYW24ijrj
         H36rk431Bqe9FP7xq2sGb8FN9ZGmAwDAp5cO4=
Message-ID: <a08621850808040418wf7c7a4awe192eeb6865cf975@mail.gmail.com>
Date: Mon, 4 Aug 2008 13:18:21 +0200
From: "Dushan Tcholich" <dusanc@gmail.com>
To: "Edward Shishkin" <edward.shishkin@gmail.com>
Subject: Re: reiser4 for 2.6.27-rc1
Cc: "Ryan Hope" <rmh3093@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
       "Ric Wheeler" <ricwheeler@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Reiserfs mailing list" <reiserfs-devel@vger.kernel.org>
In-Reply-To: <4896E3DC.4070704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com>
	 <20080801162548.GD8654@mit.edu>
	 <48f7fe350808010934k32b9de09we657e57087a3e3a5@mail.gmail.com>
	 <20080801164541.GF8654@mit.edu> <489352D8.2020700@gmail.com>
	 <489390C6.8020903@gmail.com>
	 <48f7fe350808020847iff03890nc6d910f7b77fee9e@mail.gmail.com>
	 <4894E621.8090300@gmail.com>
	 <48f7fe350808021618j12841ab3v85c219766c724150@mail.gmail.com>
	 <4896E3DC.4070704@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well as I remember akpm and hch both said that these "plugins" are
just a way of modular programing, and not layering violation, but I
just can't find those mails now, there were a lot of them.


On Mon, Aug 4, 2008 at 1:11 PM, Edward Shishkin
<edward.shishkin@gmail.com> wrote:
> Ryan Hope wrote:
>> So the purpose of that "plugins" document is just to "defend" the
>> present state of the reiser4 code?
>>
>
> Yes. In particular.
>
> Plugins stuff is a way of data storage optimization and its
> removing definitely would be a mistake. What can arise here
> again is complaints about "layering violation". However,
> addressing them doesn't necessarily mean removing the whole
> plugin stuff. I hope that this document will help such discussions
> to be more constructive.
>
> Thanks,
> Edward.
>
>> On Sat, Aug 2, 2008 at 6:56 PM, Edward Shishkin
>> <edward.shishkin@gmail.com> wrote:
>>
>>> Ryan Hope wrote:
>>>
>>>> Can you explain a little more what this "plugin design documentation"
>>>> actually is and how it supposed to help?
>>>> -Ryan
>>>>
>>>>
>>>>
>>> This document is to define plugins, etc primitives (like conversion
>>> of run-time objects) used in reiser4, and to describe all reiser4
>>> interfaces, so that it will be clear that VFS functionality is not
>>> duplicated, there are not VFS layers inside reiser4, etc. (many items
>>> are devoted to interaction between VFS and reiser4).
>>> I am sorry, but these concepts (which are very central) have not been
>>> worked out carefully enough at the moment of this 3-year-old review:
>>> http://kerneltrap.org/node/5330
>>>
>>> Edward.
>>>
>>>
>>>> On Fri, Aug 1, 2008 at 6:40 PM, Edward Shishkin
>>>> <edward.shishkin@gmail.com> wrote:
>>>>
>>>>
>>>>> Ric Wheeler wrote:
>>>>>
>>>>>
>>>>>> Theodore Tso wrote:
>>>>>>
>>>>>>
>>>>>>> On Fri, Aug 01, 2008 at 12:34:53PM -0400, Ryan Hope wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>> Hi, I am here :)
>>>>> Join our mailing list:
>>>>>
>>>>> http://vger.kernel.org/vger-lists.html#reiserfs-devel
>>>>> http://marc.info/?l=reiserfs-devel&r=1&w=2
>>>>>
>>>>> There are many interesting tasks to resolve/investigate..
>>>>>
>>>>>
>>>>>
>>>>>>>> Hmmm, removing the plugin support might not be so hard....  I might
>>>>>>>> have to try this...
>>>>>>>>
>>>>>>>>
>>>>> Please, don't try to do this.
>>>>>
>>>>> I am working on the plugin design document. It will be ready
>>>>> approximately in September. I believe that it'll address all the
>>>>> mentioned complaints.
>>>>>
>>>>>
>>>>>
>>>>>>>> I am not impressed with btrfs yet.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>> Well, if you're going to work on reiser4 (and I think there were other
>>>>>>> people who had also expressed interest/plans to work on it; you might
>>>>>>> try doing a search on the various mailing lists so you can coordinate
>>>>>>> with them and avoid duplicating work), my suggestion to you would be
>>>>>>> to find the comments that were made by the reviewers way back when,
>>>>>>> and make sure those comments have been addressed.
>>>>>>>
>>>>>>> Then, re-requests a code review, and promise that you won't abuse, and
>>>>>>> insult the integrity and impugn the motivations of the reviewers
>>>>>>>
>>>>>>>
>>>>> Well, Ted, I'll promise ;)
>>>>> We'll adhere strictly the propositional logic in the review thread..
>>>>>
>>>>> Thanks,
>>>>> Edward.
>>>>>
>>>>>
>>>>>
>>>>>>> like
>>>>>>> Hans did, and hopefully after they review the code, fix those problems
>>>>>>> as well.  Then you can try resubmitting for inclusion.
>>>>>>>
>>>>>>> Best regards,
>>>>>>>
>>>>>>>                                              - Ted
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>> My most up to date information is that Edward is still actively
>>>>>> working on reiser4....
>>>>>>
>>>>>> ric
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
