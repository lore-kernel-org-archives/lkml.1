Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYHMNiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYHMNiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYHMNiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:38:04 -0400
Received: from barnes.cubic.ch ([78.46.44.112]:46798 "EHLO barnes.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbYHMNiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:38:01 -0400
Message-ID: <48A2E391.3080404@cubic.ch>
Date: Wed, 13 Aug 2008 15:37:21 +0200
From: Tim Tassonis <timtas@cubic.ch>
Reply-To: timtas@cubic.ch
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Adrian Bunk <bunk@kernel.org>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: reiser4 for 2.6.27-rc1
References: <4896F56D.7080503@cubic.ch> <20080813125807.GC6995@ucw.cz>	 <20080813131839.GB26351@cs181140183.pp.htv.fi> <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>
In-Reply-To: <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.9 (--)
X-Spam-Report: Spam detection software, running on the system "barnes.cubic.ch", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Michael Krufky wrote: > On Wed, Aug 13, 2008 at 9:18 AM, Adrian
	Bunk <bunk@kernel.org> wrote: >> On Wed, Aug 13, 2008 at 02:58:08PM +0200,
	Pavel Machek wrote: >>> On Mon 2008-08-04 14:26:21, Tim Tassonis wrote: >>>>>
	Why is reiser4 still not in a vanilla kernel for >>>>> testing. I have had
	>>>>> to apply the reiser4 patches from -mm kernels to >>>>> vanilla based
	>>>>> patchset for over a year now. Reiser4 works fine, what >>>>> will it
	take to >>>>> get it included in vanilla? Here is a patch to add >>>>> reiser4
	to >>>>> 2.6.27-rc1: >>>>> >>>>> http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch
	>>>>> >>>>> -Ryan >>>> A good thing for a start would be to rename the whole
	>>>> thing to something else, for obvious reasons. >>> Whats wrong with reiser4
	name? >>> >>> Pavel >>> (or am I feeding a troll?) >> Not wanting a new filesystem
	named after a convicted murderer is not >> a trollish suggestion. > > > Regardless
	of the murder conviction, I still believe that the guy > should get credit
	for his work. > > Reiserfs is a name that we all know of, regardless of how
	current we > are with the news (although you'd have to be PRETTY far behind
	if you > don't know about the crime) > > The current reiserfs filesystems
	aren't being renamed -- are they?? > > Does it really hurt to keep his name
	there? I think it should just go as-is. [...] 
	Content analysis details:   (-2.9 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.5 DNS_FROM_RFC_BOGUSMX   RBL: Envelope sender in bogusmx.rfc-ignorant.org
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> On Wed, Aug 13, 2008 at 9:18 AM, Adrian Bunk <bunk@kernel.org> wrote:
>> On Wed, Aug 13, 2008 at 02:58:08PM +0200, Pavel Machek wrote:
>>> On Mon 2008-08-04 14:26:21, Tim Tassonis wrote:
>>>>> Why is reiser4 still not in a vanilla kernel for
>>>>> testing. I have had
>>>>> to apply the reiser4 patches from -mm kernels to
>>>>> vanilla based
>>>>> patchset for over a year now. Reiser4 works fine, what
>>>>> will it take to
>>>>> get it included in vanilla? Here is a patch to add
>>>>> reiser4 to
>>>>> 2.6.27-rc1:
>>>>>
>>>>> http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch
>>>>>
>>>>> -Ryan
>>>> A good thing for a start would be to rename the whole
>>>> thing to something else, for obvious reasons.
>>> Whats wrong with reiser4 name?
>>>
>>>                                                       Pavel
>>>                       (or am I feeding a troll?)
>> Not wanting a new filesystem named after a convicted murderer is not
>> a trollish suggestion.
> 
> 
> Regardless of the murder conviction, I still believe that the guy
> should get credit for his work.
> 
> Reiserfs is a name that we all know of, regardless of how current we
> are with the news (although you'd have to be PRETTY far behind if you
> don't know about the crime)
> 
> The current reiserfs filesystems aren't being renamed -- are they??
> 
> Does it really hurt to keep his name there?  I think it should just go as-is.

Well, in my opinion, there is little point in renaming reiserfs 3 now, 
as it is basically obsolete anyway and I suppose will disappear over time.

As reiser4 is not yet in and would need some rework before inclusion 
anyway, the name could be fixed easily and I do think it would be a bit 
irritating to just completely ignore real-world issues.

As for giving credit, I wasn't advocating in removing authorship 
attribution (that's what giving credit means to me), but calling the 
filesystem after himself was always a bit egocentric anyway. We don't 
have t'sofs, engelfs, molnarsched and stuff like that.

And yes, I think Hans lost his right to decide over the name because of 
what he has done. That is no disrespect for his work, only for him as 
person in general, and I do strongly disrespect him as a person.

Tim

> 
> -Mike

