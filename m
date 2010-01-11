Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159Ab0AKXFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0AKXFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501Ab0AKXFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:05:35 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:58090 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0AKXFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WGPU9YXmAzFLZO606vnfrjABL51tCRAAOrcIAbEB69xgok697lEVN6Ww9BCYFmrDIz
         3AZMqJ6hokFdrdux9jZa974R2hHK/rL4YFEwPYVsw3D2+QaDrabHaIRTMCyJ7z7BYpsW
         UIRr2dg8wn8uwgFrhQmnXpXm1tzWexHL8dxrU=
MIME-Version: 1.0
In-Reply-To: <201001112322.14152.rjw@sisk.pl>
References: <201001090045.33784.rjw@sisk.pl> <201001112204.36724.rjw@sisk.pl>
	 <20100111214355.GA11456@radis.liafa.jussieu.fr>
	 <201001112322.14152.rjw@sisk.pl>
Date: Tue, 12 Jan 2010 09:05:34 +1000
Message-ID: <21d7e9971001111505ydf12687nbcb752e38efd493c@mail.gmail.com>
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o 
	KMS
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Julien Cristau <jcristau@debian.org>, Dave Airlie <airlied@linux.ie>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 8:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 11 January 2010, Julien Cristau wrote:
>> On Mon, Jan 11, 2010 at 22:04:36 +0100, Rafael J. Wysocki wrote:
>>
>> > Hmm, are you trying to say radeon is better at that?
>> >
>> > My experience is quite the opposite to be honest.
>> >
>> radeon kms is in staging, doesn't pretend to be stable and force all
>> users to the experimental paths.  So yes, I would say radeon is better
>> at that.
>
> I guess I should have been more precise.
>
> All of my test boxes with ATI/AMD graphics hardware regressed after upgrading
> from openSUSE 11.1 to openSUSE 11.2, in different ways, because of the user
> space part of the radeon driver.  Of course, you can argue that the dristro
> picked up particularly bad release of the driver, but from the user's point of
> view it actually doesn't matter whether the breakage is in the kernel part or
> in the user space part of the driver.  The difference is, however, that the
> breakage in the kernel is fixed _way_ faster than the breakage in the user
> space, so I very much prefer the Intel people pushing new features aggressively
> and fixing bugs related to that, then the situation where I need to deal with
> the broken user space driver, while the KMS radeon is still not reliable
> enough.
>
> IOW, if your user space driver worked 100% of the time, I'd totally agree, but
> that's not the case, at least as far as I see it.
>

Are you using the Novell radeonhd driver? (I think SuSE default to this for all
cards > r500).

This isn't the driver that is developed by the opensource community and
really your distro is where you complain about that sort of regression.

The wierd thing is we see distro picking up fixes for userspace
drivers *much* quicker
if their teams are the on the ball since they are only a small
component to upgrade,
with the kernel you find most distro fire and forget, so if 2.6.31
doesn't work on your
hw you'll wait 6 months to find out that 2.634 doesn't work either.

Since ppl aren't targetting stable properly distros are left to fend
for themselves
when it comes to backporting large amounts of changes, and you find most
distros just don't bother.

Dave.
