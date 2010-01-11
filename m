Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217Ab0AKUMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0AKUMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143Ab0AKUMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:12:39 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:37215 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab0AKUMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:12:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J7QU0Y/kTabkdvgsfyQQu1w0Oyro7k2cAH21s9dwfvejIQFXwvo/eMyTPqDzmyZO8d
         mVH9hmthMPXn4eRPJoBRKP6ZIt+IsNpVbsUOQ1C/bMqCiiLQ6m/OWd4Gir8e+GuvhRZ0
         iTKhN6+ifGm11NvQhq6Y+mBwyb+rVMgP8p13M=
MIME-Version: 1.0
In-Reply-To: <20100111083825.4c2bb7b3@jbarnes-piketon>
References: <201001090045.33784.rjw@sisk.pl>
	 <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
	 <alpine.DEB.2.00.1001090214220.21286@skynet.skynet.ie>
	 <20100108185041.7aae6c01@jbarnes-piketon>
	 <20100109120141.GA4319@localhost.localdomain>
	 <alpine.LFD.2.00.1001091012080.7821@localhost.localdomain>
	 <21d7e9971001091332v23ac0e28m1b1890cd667aacb8@mail.gmail.com>
	 <20100111083825.4c2bb7b3@jbarnes-piketon>
Date: Tue, 12 Jan 2010 06:12:37 +1000
Message-ID: <21d7e9971001111212h1ded5292l94d514c6f5a47cd4@mail.gmail.com>
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o 
	KMS
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jerome Glisse <glisse@freedesktop.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 2:38 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sun, 10 Jan 2010 07:32:30 +1000
> Dave Airlie <airlied@gmail.com> wrote:
>> I'm in the 2-3 years at a minimum, with at least one kernel with no
>> serious regressions in Intel KMS, which we haven't gotten close to
>> yet. I'm not even sure the Intel guys are taking stable seriously
>> enough yet. So far I don't think there is one kernel release (even
>> stable) that works on all Intel chipsets without
>> backporting patches. 2.6.32 needs the changes to remove the messed up
>> render clock hacks which should really have been reverted a lot
>> earlier since we had a lot of regression reports. The number of users
>> using powersave=0 to get anything approaching useable is growing etc.
>
> But you could apply that argument to the existing DRM code (not just
> Intel) as well; lots of things are broken or unimplemented and never
> get fixed.  I'd say the right metric isn't whether regressions are
> introduced (usually due to new features) but whether the driver is
> better than the old userspace code.  For Intel at least, I think we're
> already there.  The quality of the kernel driver is higher and it has
> many more features than the userspace implementation ever did.  That's
> just my subjective opinion, but I've done a *lot* of work on our bugs
> both in userspace and in the kernel, so I think it's an accurate
> statement.

The problem is at any single point in time I'm not sure a kms kernel
exists that works across all the Intel hw, which from a distro POV is a real
pain in the ass, a regression gets fixed on one piece of hw just as
another on a different piece gets introduced.

I'd really like if Intel devs could either slow it down and do more testing
before pushing to Linus, or be a lot quicker with the reverts when stuff
is identified. The main thing is the render reclocking lately, thats been a
nightmare and as far as I can see 2.6.32.3 still has all the issues,

>
> It doesn't have to happen anytime soon, I was just thinking that
> removing the old, pre-KMS code would make it easier to avoid
> introducing regressions since we'd have one less config (a bit one
> atthat) to worry about.

Maybe in 3-4 years.

Dave.
