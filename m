Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbZFZTdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbZFZTdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZFZTdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:33:44 -0400
Received: from mail.lang.hm ([64.81.33.126]:58638 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZFZTdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:33:43 -0400
Date: Fri, 26 Jun 2009 12:32:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Al Boldi <a1426z@gawab.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/15] drbd: a block device for HA clusters
In-Reply-To: <200906262142.30895.a1426z@gawab.com>
Message-ID: <alpine.DEB.1.10.0906261229170.9159@asgard>
References: <1246017715-9821-1-git-send-email-philipp.reisner@linbit.com> <200906261843.59635.a1426z@gawab.com> <1246032541.3925.53.camel@mulgrave.site> <200906262142.30895.a1426z@gawab.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Al Boldi wrote:

> James Bottomley wrote:
>> On Fri, 2009-06-26 at 18:43 +0300, Al Boldi wrote:
>>> James Bottomley wrote:
>>>> On Fri, 2009-06-26 at 17:15 +0300, Al Boldi wrote:
>>>>> Philipp Reisner wrote:
>>>>>> Short Description
>>>>>>
>>>>>>   DRBD is a shared-nothing, synchronously replicated block device.
>>>>>
>>>>> What do you mean by "shared-nothing"?
>>>>
>>>> If you actually type "shared nothing" into google, the first hit will
>>>> be the wikipedia article describing this.
>>>
>>> Sure, but the point here is to choose a description that is clear and
>>> self-explanatory, and "shared-nothing" is neither clear nor
>>> self-explanatory.
>>
>> It is clear because everyone agrees on the definition.
>
> Everyone involved in the project maybe, but not everyone interested in "a
> block device for HA clusters".  And you don't want to turn them of by using
> terminology to explain terminology, especially when it's misleading.  Many
> OpenSource projects fail merely for this reason.

anyone who knows the terminology for HA clusters should understand the 
term "shared-nothing"

do you really want the full explination to have to be squeezed into this 
sentance? or even the patch description?

David Lang

>> And it is self
>> explanatory because it's an art term for a well defined concept which
>> forms one of the building blocks of the nomenclature used in clustering.
>> Even if you're not familiar with clustering terminology, the definitions
>> are easy to find via search engines.
>>
>> If you want to find useful quibbles, the term synchronously is wrong:
>> DRBD is capable of both synchronous and asynchronous replication.
>
> Ok, so maybe change the description to reflect this capability.
> Something like:  DRBD is an independent, synch/async replicated block device.
>
>
> Thanks!
>
> --
> Al
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
