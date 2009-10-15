Return-Path: <linux-kernel-owner+w=401wt.eu-S934876AbZJOQmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876AbZJOQmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbZJOQmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:42:40 -0400
Received: from mail.lang.hm ([64.81.33.126]:53375 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbZJOQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:42:40 -0400
Date: Thu, 15 Oct 2009 09:39:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>
Subject: Re: removing existing working drivers via staging
In-Reply-To: <4AD74ED7.9070501@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.2.00.0910150936310.22169@asgard.lang.hm>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <4AD74ED7.9070501@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Stefan Richter wrote:

> david@lang.hm wrote:
>> I missed this discussion in the thread "Moving drivers into
>> staging (was Re: [GIT PULL] SCSI fixes for 2.6.32-" and I suspect that
>> many others did as well
>>
>> for those that missed it, as I understand it the proposal is that 'ugly'
>> (working drivers that don't do things the kernel way and are perceived as
>> not being commonly used anymore) drivers will get moved into staging, and
>
> There was mention of "abandoned and unused" drivers (rather than "not
> /commonly/ used anymore"), see e.g.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-10/msg05204.html
> (2nd to last paragraph; thread continues with Greg's follow-up).

how can you tell if a driver is "unused"? (other than leaving it broken 
for several years and getting no complaints)

>> if the driver maintainers do not clean them up within 6-9 months they will
>> be removed entirely.
>>
>> the expectation is that if there are no maintainers for the driver who
>> care enough to do the cleanup they should be removed (with interested
>> users being able to take over maintaining the drivers if there the
>> maintainers are MIA)
>>
>> I have several reactions to this
>>
>> I think that 6-9 months (2-3 releases) is _far_ too short for users to
>> notice. most users will be using a distro kernel that is on a release
>> cycle longer than this (even if they are not using a 'enterprise' distro),
>> so their first inkling of a problem will be the driver disappearing on
>> them. Yes the driver can be recovered through git, bit at that point
>> there is going to be catch-up changes to make.
>>
>> What happened to the desire that Linux would be able to use anything, and
>> once a driver was upstream changes to the kernel that would break it
>> should be fixed by whoever is introducing those changes? This seems to be
>> moving in the direction of only having drivers for fairly current, fairly
>> common hardware.
>
> AFAIU, mostly just code which is known to _not work_ anymore or has been
> functionally replaced by an alternative drops out of the mainline.  This
> idea of using drivers/staging/ in the process is surely not going to
> change that in principle; it will only raise awareness among active
> kernel developers better than feature-removal-schedule.txt can do.

I don't disagree with dropping code that has been replaced by an 
alternative. and I don't disagree much with dropping broken code.

however, what I think I saw proposed was to move drivers that need to be 
'cleaned up', to staging and then dropping them if they don't get cleaned.

David Lang
