Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZLCV2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZLCV2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZLCV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:28:31 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33571 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZLCV2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:28:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RjqrG3lJVD0aIos1rb5Oa/OZ3IrOT3TsVImmnEtEpE+PCCfv1pxh61Q7bQsxvlWPHc
         /gfsEWepL6m5XvYj2bMhQ289Y91QcOwLkuHZcTrjNTWep3cu+oi/b/JXcPduZAadlckY
         bCcJahYtQMRtLwZLpK9j8oqtu6KQ3GlkXcNG4=
Message-ID: <4B182D82.8060904@garzik.org>
Date: Thu, 03 Dec 2009 16:28:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032126.58129.bzolnier@gmail.com> <4B18220B.7010305@garzik.org> <200912032201.55115.bzolnier@gmail.com>
In-Reply-To: <200912032201.55115.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 04:01 PM, Bartlomiej Zolnierkiewicz wrote:
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

uhwhu?  You brought up distributions.


>> patches go upstream, and are then distributed widely, to eliminate
>> massive amounts of duplicated work across distributions.
>>
>> You are essentially implying that each distribution must
>>
>> 	- discover your tree
>> 	- look through the mailing list to figure out why each of
>> 	  ~80 changes are not upstream
>> 	- individually make a decision on each of ~80 changes
>> 	- actively track your tree for updates, repeating this process
>> 	  over and over again
>
> Not really.
>
> I'm only saying that the upstream is so much hassle to deal with it that
> it is up to people wanting to see my changes upstream to do the work on
> integrating them upstream if they want to see them in upstream faster.
>
> Fair enough?

I respect your opinion, sure.  And respect that your time is your own. 
And appreciate you spending that time to batch together some patches.

But it is simple logic that a non-standard distribution method for your 
changes implies a self-imposed limited distribution, with possibly 
useful fixes and changes not getting into the hands of users that can 
use them.

That's your choice -- but it surprised me, is all.  Usually developers 
are more eager to get their changes into wide distribution, because that 
benefits the most Linux users.

If you fail to send changes upstream, most people will assume that you 
do not consider your changes "ready" for users, "ready" for wide 
distribution and use.  Because that is the common practice for nearly 
all other Linux kernel developers in all subsystems.

	Jeff


