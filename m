Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbZL0UhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbZL0UhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZL0UhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:37:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42993 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZL0UhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:37:18 -0500
Date: Sun, 27 Dec 2009 21:37:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj?nnev?g <arve@android.com>, Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Subject: Re: tree with htc dream support
Message-ID: <20091227203704.GK11737@elf.ucw.cz>
References: <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
 <1260627482.20913.7.camel@desktop>
 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
 <20091213212504.GD5114@elf.ucw.cz>
 <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
 <20091227093537.GD11737@elf.ucw.cz>
 <20091227201514.GA29174@elf.ucw.cz>
 <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > I do plan to look at these, but I don't know when I'll get to it.
> >>
> >> So... this switches qdsp5 code from private version to version in
> >> staging. It actually boots.
> >
> > And when I replace .c's in qdsp5 with -msm version, it also works,
> > with diff being reasonably small.
> >
> > Now... how does camera driver work? I did not drivers/media/video/msm/
> > driver into the kernel, but camera application seems to still
> > work...?!
> 
> Depends which version of the camera userspace code you've got.  The
> stuff for cupcake/donut talks directly to the DSP and the DSP
> interacts with the VFE (video frontend, the camera data transport).  I
> believe the new camera driver bypasses some (all?) of that and deals
> with the VFE directly.  At least on 8k that's how it works (no DSP
> involvement at all).

I have 1.5 listed as "firmware version" under "about phone". I guess
that means "cupcake". Ok, so that looks like I do not have easy way of
testing camera driver, because my userland does not need it...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
