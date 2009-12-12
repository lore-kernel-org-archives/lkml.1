Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbZLLCCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbZLLCCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 21:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761207AbZLLCCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 21:02:48 -0500
Received: from mail.lang.hm ([64.81.33.126]:59715 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbZLLCCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 21:02:47 -0500
Date: Fri, 11 Dec 2009 18:02:43 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
In-Reply-To: <200912032201.55115.bzolnier@gmail.com>
Message-ID: <alpine.DEB.2.00.0912111801420.10307@asgard.lang.hm>
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032126.58129.bzolnier@gmail.com> <4B18220B.7010305@garzik.org> <200912032201.55115.bzolnier@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Bartlomiej Zolnierkiewicz wrote:

> On Thursday 03 December 2009 09:39:39 pm Jeff Garzik wrote:
>> On 12/03/2009 03:26 PM, Bartlomiej Zolnierkiewicz wrote:
>>> On Thursday 03 December 2009 09:11:19 pm Jeff Garzik wrote:
>>>> On 12/03/2009 02:45 PM, Bartlomiej Zolnierkiewicz wrote:
>>>>> On Thursday 03 December 2009 06:53:59 pm Jeff Garzik wrote:
>>>>>> On 12/03/2009 07:39 AM, Bartlomiej Zolnierkiewicz wrote:
>>>>>>> On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
>>>>>>>> The merge window is upon us, which by strict rules means that anything
>>>>>>>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
>>>>>>>>
>>>>>>>> However, bug fixes and the like should definitely be in 2.6.33.
>>>>>>>> ->init_host is definitely 2.6.34 material.  Some of the other stuff
>>>>>>>> could go either way.
>>>>>>
>>>>>>> If you would like to apply some of my patches to 2.6.33 you are more than
>>>>>>> welcome to do it.  I can even prepare separate git tree with specific changes
>>>>>>> to make it easier for you once you tell me which changes you would like to
>>>>>>> see in it.
>>>>>>
>>>>>> OK, great.
>>>>>>
>>>>>> Can you prepare a patchset containing only fixes?  Comment-only changes
>>>>>> are acceptable too.  Trivial changes too, if they are extremely trivial :)
>>>>>>
>>>>>> Include nothing that adds features, removes or unifies drivers, etc.
>>>>>
>>>>> Since this is pretty high-level description and some changes fall into
>>>>> many categories at once (i.e. addition of proper PCI Power Management
>>>>> handling could be considered both as a fix and as a feature) I prepared
>>>>> a rather conservative set of changes (which means that unfortunately
>>>>> it misses many enhancements available in my tree):
>>>>>
>>>>>> Please do it in standard kernel submit form, which is either
>>>>>> (a) repost the patches (yes, again) being submitted for 2.6.33, or
>>>>>> (b) a standard git pull request, which includes shortlog, diffstat, and
>>>>>> all-in-one diff.
>>>>>
>>>>> Thank you for the detailed explanation of the standard kernel submit
>>>>> form (I wonder how would I know this otherwise :) but the thing is that
>>>>> at the current moment I'm not submitting anything to the upstream.
>>>>
>>>> Ok, that explains my confusion, then.  I had thought you intended to get
>>>> this stuff upstream, and into users' hands.
>>>
>>> Interesting argument but the vast majority of users use distribution kernels
>>> which are not upstream and I doubt that any self-respecting distribution would
>>> miss such amount of fixes.
>>
>> Interesting argument, but applied across 1000+ developers this is
>> clearly an unscalable development model for distributions.  Thus,
>
> Interesting that you have brought distributions' convenience before
> non-distribution developers' one.

and you are leaving those of us who use kernel.org out in the cold 
(forcing all non-distribution users to go through all the work that Jeff 
described)

I'm not sure who you see as benifiting from this approach.

David Lang

