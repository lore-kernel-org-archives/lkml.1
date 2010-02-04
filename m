Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab0BDU2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:28:09 -0500
Received: from mail.lang.hm ([64.81.33.126]:41208 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab0BDU2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:28:04 -0500
Date: Thu, 4 Feb 2010 12:27:33 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
In-Reply-To: <20100204202254.GA24716@elte.hu>
Message-ID: <alpine.DEB.2.00.1002041225010.3707@asgard.lang.hm>
References: <20100204170826.GA16397@elte.hu> <20100204173602.GA19855@srcf.ucam.org> <20100204175445.GB27361@elte.hu> <20100204175928.GA20595@srcf.ucam.org> <20100204181218.GA6175@elte.hu> <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
 <20100204190649.GB6665@elte.hu> <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com> <20100204193232.GD6665@elte.hu> <20100204115316.69beee75@jbarnes-piketon> <20100204202254.GA24716@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Ingo Molnar wrote:

> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
>> On Thu, 4 Feb 2010 20:32:32 +0100
>> Ingo Molnar <mingo@elte.hu> wrote:
>>> Nobody has reacted to my related boot hang bugreport yet - and it's
>>> detailed and fully reproducible (so i can test any proposed fixes as
>>> well in short order). I.e. my limited testing has triggered two
>>> separate bugs in the same driver - and this will show up in -rc7.
>>>
>>> It might be all OK and no-one else will see trouble. Or past patterns
>>> might repeat themselves and i might simply be an early bird for
>>> trouble to come.
>>>
>>> My (oft repeated) point is that adding new sub-features to existing
>>> drivers is not what we do in late -rc's: there's simply not enough
>>> time to shake out bugs/regressions in them.
>>>
>>> We introduce new functionality to existing drivers in the merge
>>> window - in the two weeks following a stable kernel's release.
>>
>> This is the .config issue right?  It doesn't sound like the bug is new,
>> you're just seeing now it because of the way you run tests.  It shouldn't
>> affect any more or fewer users than it did before, and reverting the "move
>> radeon KMS out of staging" won't fix the bug at all or prevent anyone from
>> seeing it.  People using KMS will still use KMS and people without it
>> won't, [...]
>
> I think you are missing my point. My point is very simple: existing non-KMS
> users of CONFIG_DRM_RADON=y (a pre-existing driver) might turn on the new
> sub-feature (CONFIG_DRM_RADEON_KMS=y), in the expectation that this is a safe
> addition to his currently well-working driver.
>
> ( I have to confess i do that all the time for drivers that work well for me,
>  and if it pops up in a late -rc i sure expect it to be safe to enable. I
>  dont even read the help text most of the time - if the single-line summary
>  sounds useful i enable it. Especially if the Kconfig help entry says it's
>  safe with a new distro, it's not CONFIG_EXPERIMENTAL, it's not marked
>  CONFIG_BROKEN, it's not in CONFIG_STAGING, etc. )

forget the people testing the rc kernels, what about people who will see 
this in the released kernel?

David Lang
