Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0BDUjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:39:52 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:55440 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0BDUjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:39:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wQkOeg0JhghM5bYtzk8/A+iBpexgw6Fpg9KomT15iDrotwT74Iu3bciEtBsodRuh+C
         40e3RG10+RBFmRQZjiOYfm1mYARTLUfRLAzXIhRyARTKcIw3//4EW/EXpwNr/k4UJMkX
         oX0rRhmNxvGBeMQx7AgkgQ3FW/l5JeEPE0u8w=
MIME-Version: 1.0
In-Reply-To: <20100202154450.GC27314@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
	 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
	 <20100202081727.GA6788@elte.hu>
	 <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
	 <20100202154450.GC27314@elte.hu>
Date: Fri, 5 Feb 2010 06:39:50 +1000
Message-ID: <21d7e9971002041239i5e842698pd8a775f833fc5d51@mail.gmail.com>
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

On Wed, Feb 3, 2010 at 1:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Airlie <airlied@linux.ie> wrote:
>
>> > It's the moving of radeom KMS out of staging after -rc6 that causes it,
>> > because it brought it into the scope of my testing:
>> >
>> >  f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
>> >
>> > So at least on this box it's clearly not ready for mainline enablement
>> > yet. I've attached the revert patch further below.
>>
>> Its not enabled by default so reverting this doesn't make much sense.
>
> I boot allyesconfig kernels regularly, which testing method works fine with
> another 2000+ upstream drivers. (including the dozens of drivers which match
> to active hardware components on that box)

Okay this was something I wondered about, since these are *not* allyesconfig
.configs, I've generated some and CONFIG_FB_RADEON is always on here, and
you seem to not have that enabled (not that enabling it is a good idea
it is in fact
a really bad idea).

So do you have something you are running after allyesconfig to fix things? or
have you just got a config that is close enough to allyesconfig.

I'm building kernels with your .config now and boot testing them on
the full range of
hardware I have/

Dave.
