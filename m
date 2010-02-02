Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0BBIhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:37:41 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:61681 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0BBIhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:37:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dA6LBvtvHxc/leKeb8GOaroN7Dm1CXYdlW2LDARsK8TlN7nmoETT/ipeJunTmTgp2i
         S3W4heX0dg12RkspHqTHo/dYXsw2GrVPj9QbaOxmB1fasrIHI6BFE+nzxfj6nO3hx5lj
         xIR0EbSI6P2G7pRlcGTxJgWb9j9eUS5qKlIZM=
MIME-Version: 1.0
In-Reply-To: <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
	 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
	 <20100202081727.GA6788@elte.hu>
	 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
Date: Tue, 2 Feb 2010 18:37:38 +1000
Message-ID: <21d7e9971002020037r13de7df7t1450cecc1f4a4fea@mail.gmail.com>
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

On Tue, Feb 2, 2010 at 6:35 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Feb 2, 2010 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Dave Airlie <airlied@linux.ie> wrote:
>>
>>> > Hi Linus,
>>> >
>>> > Please pull the 'drm-linus' branch from
>>> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>>> >
>>>
>>> I've also added an oops fix I seem to lose off my radar to this tree.
>>>
>>> commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
>>> Author: Michel D??nzer <daenzer@vmware.com>
>>> Date:   Fri Jan 22 09:20:00 2010 +0100
>>>
>>>     drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
>>
>
> Wierd this suggests something else is wrong on that machine can you get me
> the whole dmesg? I'm guessing some iommu or swiotlb issue.
>
> I've asked Jerome to fix the oops, but really anyone with an old
> .config won't get
> hit by this, and we've booted this on quite a lot of machines at this point.
>

Ideas keep flooding in here, did you softboot from the old UMS driver? or
coldboot? does coldbooting help?

Dave.
