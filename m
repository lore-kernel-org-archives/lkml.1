Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0BFLPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 06:15:10 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:60495 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0BFLPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 06:15:07 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2010 06:15:07 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S+NitWQ6agg/h7szT1dcDFS7Seu+sZwWxSiHwX6wThv52qEGy1IoQnMjpzk4Zgj4V7
         OblJI8wpe/JOc0ZILC0tAZULL6MAayFtdqqV8ivo1G+ky5Ta0ztzttO+vg/VIWotSMUu
         NkU0kuHA8K1QJiMWQ8hbzMZKBwLDDjaWaDU5A=
MIME-Version: 1.0
In-Reply-To: <20100204132346.85ea0d9f.akpm@linux-foundation.org>
References: <20100204175445.GB27361@elte.hu>
	 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
	 <20100204190649.GB6665@elte.hu>
	 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
	 <20100204193232.GD6665@elte.hu>
	 <20100204115316.69beee75@jbarnes-piketon>
	 <20100204202254.GA24716@elte.hu>
	 <20100204204829.GA24608@srcf.ucam.org>
	 <20100204210559.GC19050@elte.hu>
	 <20100204132346.85ea0d9f.akpm@linux-foundation.org>
Date: Sat, 6 Feb 2010 13:10:04 +0200
Message-ID: <94a0d4531002060310v230bf1a8lf93c7f94098b46d6@mail.gmail.com>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch 
	out of staging."
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 11:23 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 4 Feb 2010 22:05:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>> Regressions are not limited to 'same config' kernels, last i checked. If that
>> has changed (or if i'm misunderstanding it) then it would be nice to hear a
>> clarification about that from Linus.
>>
>> The way i understand it is that there are narrow exceptions from the
>> regression rules, such as completely new drivers for which there can be no
>> prior expectation of stability by users. (but for even them we are generally
>> on the safer side to list bugs in them as regressions as well - especially if
>> we expect many users to enable it.)
>>
>> AFAIK there's no exception for new sub-features of existing facilities or
>> drivers, even if it's default-disabled.
>>
>> This issue materially affects quite a few bugs i'm handling as a maintainer.
>> Many of them are under default-off config options - most new aspects to
>> existing code are introduced in such a way. It would remove quite a bit of
>> urgent-workload from my workflow if i could strike them from Rafael's list
>> and could deprioritize them as "plain bugs", to be fixed as time permits.
>>
>> IMHO it would be rather counter-productive to kernel quality if we did that
>> kind of regression-lawyering though.
>
> Yes, it's mainly semantics.
>
> From the user's point of view
>
> kernel N: boots, works, plays nethack
> kernel N+1: goes splat
>
> That kernel regressed for that user.  He'll shrug and will go back to
> kernel N and we lost an N+1 tester.  And the distros who ship N+1 get a
> lot of hack work to do.
>
> If the feature is this buggy, it was wrong to make it accessible in Kconfig.

That's why some features are marked as _experimental_ and disabled by
default. If the feature is not marked as such, then yeah, I would
consider it a regression.

-- 
Felipe Contreras
