Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZLCUjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZLCUjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZLCUjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:39:35 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62505 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZLCUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Vgs6CQMqBLxJ2lG2DqmShRR+KKIsCz8oJmuAZiI/QmzRQkxYVZXtGplKdeeF8CnP9+
         i2UsZcJC2opJN+uOfKLoS0h/SUCN1JnU2m9F7W/wtQnCaVii0PfPi/OVcXBzftAZaj/x
         84jKxF8Dyd1RPbb1lkfax5RP/l+YEx8iLtb5E=
Message-ID: <4B18220B.7010305@garzik.org>
Date: Thu, 03 Dec 2009 15:39:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032045.48728.bzolnier@gmail.com> <4B181B67.5080503@garzik.org> <200912032126.58129.bzolnier@gmail.com>
In-Reply-To: <200912032126.58129.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 03:26 PM, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 03 December 2009 09:11:19 pm Jeff Garzik wrote:
>> On 12/03/2009 02:45 PM, Bartlomiej Zolnierkiewicz wrote:
>>> On Thursday 03 December 2009 06:53:59 pm Jeff Garzik wrote:
>>>> On 12/03/2009 07:39 AM, Bartlomiej Zolnierkiewicz wrote:
>>>>> On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
>>>>>> The merge window is upon us, which by strict rules means that anything
>>>>>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
>>>>>>
>>>>>> However, bug fixes and the like should definitely be in 2.6.33.
>>>>>> ->init_host is definitely 2.6.34 material.  Some of the other stuff
>>>>>> could go either way.
>>>>
>>>>> If you would like to apply some of my patches to 2.6.33 you are more than
>>>>> welcome to do it.  I can even prepare separate git tree with specific changes
>>>>> to make it easier for you once you tell me which changes you would like to
>>>>> see in it.
>>>>
>>>> OK, great.
>>>>
>>>> Can you prepare a patchset containing only fixes?  Comment-only changes
>>>> are acceptable too.  Trivial changes too, if they are extremely trivial :)
>>>>
>>>> Include nothing that adds features, removes or unifies drivers, etc.
>>>
>>> Since this is pretty high-level description and some changes fall into
>>> many categories at once (i.e. addition of proper PCI Power Management
>>> handling could be considered both as a fix and as a feature) I prepared
>>> a rather conservative set of changes (which means that unfortunately
>>> it misses many enhancements available in my tree):
>>>
>>>> Please do it in standard kernel submit form, which is either
>>>> (a) repost the patches (yes, again) being submitted for 2.6.33, or
>>>> (b) a standard git pull request, which includes shortlog, diffstat, and
>>>> all-in-one diff.
>>>
>>> Thank you for the detailed explanation of the standard kernel submit
>>> form (I wonder how would I know this otherwise :) but the thing is that
>>> at the current moment I'm not submitting anything to the upstream.
>>
>> Ok, that explains my confusion, then.  I had thought you intended to get
>> this stuff upstream, and into users' hands.
>
> Interesting argument but the vast majority of users use distribution kernels
> which are not upstream and I doubt that any self-respecting distribution would
> miss such amount of fixes.

Interesting argument, but applied across 1000+ developers this is 
clearly an unscalable development model for distributions.  Thus, 
patches go upstream, and are then distributed widely, to eliminate 
massive amounts of duplicated work across distributions.

You are essentially implying that each distribution must

	- discover your tree
	- look through the mailing list to figure out why each of
	  ~80 changes are not upstream
	- individually make a decision on each of ~80 changes
	- actively track your tree for updates, repeating this process
	  over and over again

Talk about a lot of unwanted work pushed upon OTHER people, all because 
you choose to avoid the standard upstream development process.


>>> That's it.  While this may sound strange to some people it turns out
>>> that in practice it is much less hassle for me personally to keep some
>>> of trees outside of the (sometimes greatly overrated) upstream.
>>>
>>> If knowing the above you still would like to include the aforementioned
>>> set of changes in your libata-dev tree they are at kernel.org now.
>>
>> I will go through this batch and cherry-pick.  The build fix is already
>> in my tree.  Existing kernel practice (and previous comments) indicate
>> that lists of known issues do not belong in Kconfig.  Will take a look
>> at the other stuff...
>
> Well, you were aware that they were not dropped so you could have easily told
> me that you specifically don't want this patches in the for-2.6.33 tree..

At the time you built atang-2.6.33, you were aware that those Kconfig 
changes were not wanted -at all-.

You tell others "I think that there were enough hints in my mail 
already" then fail to apply this logic to yourself.

	Jeff


