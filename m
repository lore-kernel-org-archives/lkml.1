Return-Path: <linux-kernel-owner+w=401wt.eu-S1763206AbZD1Q55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763206AbZD1Q55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZD1Q5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:57:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:32984 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZD1Q5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:57:46 -0400
Date: Tue, 28 Apr 2009 09:54:18 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>  <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org>
 <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Linus Torvalds wrote:

> On Tue, 28 Apr 2009, Tejun Heo wrote:
>>
>> I think defconfig should enable options such that it shows where
>> upstream kernel is headed, so FWIW +1 for KMS from me.
>
> I'd actually love to get rid of the stupid defconfig's entirely. They've
> lost pretty much all relevance over the years, except for specific cases
> where you might have defconfigs that are for specific platforms.
>
> IOW, the embedded kind of "per-platform defconfig" at lest is a useful
> starting point. But even there I'm not 100% sure that it makes sense to
> pollute the kernel source tree with them - they mess up things like
>
> 	git grep PREVENT_FIRMWARE_BUILD
>
> horribly.
>
> IOW, they're likely to be more pain than they are worth. And they really
> aren't useful starting points for normal people (who are probably better
> off starting with their distro kernel config) or likely even for most
> kernel developers (who hopefully have noticed that they can install a
> per-machine defconfig in /etc/kernel-config and forget about it).
>
> I'd love to just delete them all.

as a end-user creating my own configs, I use the defaults as a guide to 
understand when something moves from "we think it's a good idea" to 
"things really need this"

there's a _lot_ of stuff that goes in that is useful only is some 
situations, and the help text frequently doesn't help understanding what's 
really needed vs what the author of that feature _thinks_ is really needed 
(containers are a perfect example, they aren't needed in 99% of current 
systems, but it's actually _hard_ to really disable them completely)


you mention starting from a distro config, but most distro configs have a 
_huge_ number of things enabled that aren't needed for any particular box. 
right now it's significantly faster to start with a defconfig and enable 
hardware drivers than it is to start with a distro config and disable 
things. If a tool was available to detect the hardware and create a 
config tailored for the box, this use for a default config would go away

David Lang
