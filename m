Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0BBUez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:34:55 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:46169 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0BBUew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B8M8vN2GVEDGadbaZAQz8hXgMeOHFlYlwRI20K46pUjdDe0efXyY6zpz9KVqD8KqiU
         ZE10IVus3tSstURQ9LEeQZNTTkDKGIT7XeiyQsEq7ROyYLpDnO+qa+JIrNdH2YblpRnm
         QQMHxUDDUywvSHMbpvjzc52tNAZkEhhn9ZJhA=
MIME-Version: 1.0
In-Reply-To: <20100202154656.GD27314@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
	 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
	 <20100202081727.GA6788@elte.hu>
	 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
	 <20100202154656.GD27314@elte.hu>
Date: Wed, 3 Feb 2010 06:34:52 +1000
Message-ID: <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off 
	switch out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 3, 2010 at 1:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Airlie <airlied@gmail.com> wrote:
>
>> On Tue, Feb 2, 2010 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Dave Airlie <airlied@linux.ie> wrote:
>> >
>> >> > Hi Linus,
>> >> >
>> >> > Please pull the 'drm-linus' branch from
>> >> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>> >> >
>> >>
>> >> I've also added an oops fix I seem to lose off my radar to this tree.
>> >>
>> >> commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
>> >> Author: Michel D??nzer <daenzer@vmware.com>
>> >> Date: ? Fri Jan 22 09:20:00 2010 +0100
>> >>
>> >> ? ? drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
>> >
>>
>> Wierd this suggests something else is wrong on that machine can you get me
>> the whole dmesg? I'm guessing some iommu or swiotlb issue.
>
> This box has no known hardware or software problems, just this week it booted
> in excess of 1000 kernels so i'd exclude that angle for now.
>
> I have bisected the crash back to the DRM tree and the crash went away with
> the Kconfig revert i applied - and it got fixed by Jerome's patch. I posted
> my config and i posted the relevant boot log as well. Find below the full
> bootlog as well with vanilla -git (ab65832) and the config. (i dont think it
> matters)
>
>> I've asked Jerome to fix the oops, but really anyone with an old .config
>> won't get hit by this, and we've booted this on quite a lot of machines at
>> this point.
>
> I dont see the commit in yesterday's linux-next. It has very fresh
> timestamps:
>
>  commit f71d0187987e691516cd10c2702f002c0e2f0edc
>  Author:     Dave Airlie <airlied@redhat.com>
>  AuthorDate: Mon Feb 1 11:35:47 2010 +1000
>  Commit:     Dave Airlie <airlied@redhat.com>
>  CommitDate: Mon Feb 1 11:35:47 2010 +1000
>
> What kind of widespread testing could this commit have gotten in the less
> than 24 hours before it hit mainline?
>

Its shipping in a major distro by default, its planned to be shipped in an even
more major distro. Its been boot tested on 1000s of machines by 1000s of ppl.

Your bug isn't anything to do with this commit, its a completely separate issue,
that nobody else has reported before now and Jerome has provided a patch for.

Dave.
