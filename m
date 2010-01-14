Return-Path: <linux-kernel-owner+w=401wt.eu-S932247Ab0ANWGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0ANWGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638Ab0ANWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:06:06 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:34605 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751376Ab0ANWGD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:06:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YdTWe4kqLU2l1ek4mz9zc1W/gD22SbI76AyZ+QJOLSzTo9BbIKgbBhfjdSBwBg6uEvdwiz1oBG4/Fp7rfZPUIg1fV1b4cBcFIFD8csw+Wd18p4qj0+ru2CpqVNYTRZ6q;
Date: Thu, 14 Jan 2010 13:51:38 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Bowler <nbowler@elliptictech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie, eric@anholt.net, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
Message-ID: <20100114135138.39895280@jbarnes-piketon>
In-Reply-To: <84144f021001141325o4b54b5fdj84ee5d39fd8ddff3@mail.gmail.com>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	<84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	<20100113133357.67f9df6d@jbarnes-piketon>
	<4B4E403C.1050509@cs.helsinki.fi>
	<20100113165530.2a7e7645@jbarnes-piketon>
	<4B4F6D5F.10008@cs.helsinki.fi>
	<20100114193118.GA1203@emergent.ellipticsemi.com>
	<84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	<20100114202803.GA1749@emergent.ellipticsemi.com>
	<20100114124802.025bbcae@jbarnes-piketon>
	<84144f021001141325o4b54b5fdj84ee5d39fd8ddff3@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 23:25:57 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Jesse,
> 
> On Thu, Jan 14, 2010 at 10:48 PM, Jesse Barnes
> <jbarnes@virtuousgeek.org> wrote:
> > Many platform support this feature, and it can provide significant
> > power savings when the reduced refresh rate is low.  However, on
> > some platforms a secondary (reduced) timing is provided but not
> > actually supported by the hardware.  This results in undesirable
> > flicker at runtime.
> >
> > So disable the feature by default, but allow users to opt-in to the
> > reduced clock behavior with a new module parameter, lvds_downclock,
> > that can be set to 1 to enable the feature.
> >
> > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> >
> > --
> >
> > Nick and Pekka, please try this out and reply with your Tested-by
> > (assuming it works, if not I'll fix it up).
> 
> This gives me pretty much identical results as your original patch.
> That is, the "shakes" are gone but I still see the occasional "flash".
> Should I give Nick's patch a try to see if we're looking at the same
> issue or wait for your new patch?

Nick's patch should be the same, thanks for testing.

-- 
Jesse Barnes, Intel Open Source Technology Center
