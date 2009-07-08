Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbZGHJTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbZGHJTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbZGHJTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:19:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60639 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZGHJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:19:42 -0400
Date: Wed, 8 Jul 2009 11:19:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dima Zavin <dima@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rebecca Schultz Zavin <rebecca@android.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: Framebuffer support for HTC Dream
Message-ID: <20090708091930.GA24385@elf.ucw.cz>
References: <20090629111029.GA15514@elf.ucw.cz> <20090629123840.1e20f17d.akpm@linux-foundation.org> <a55d774e0906291300u3bb9b491r124f27fdf832b495@mail.gmail.com> <20090629211931.GD6611@elf.ucw.cz> <404ea8000906291606u600673f3r63a9ac0dfe02eea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <404ea8000906291606u600673f3r63a9ac0dfe02eea@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Will it have a maintainer?
> >>
> >> I did the original quick and dirty version for bringup.  Rebecca took
> >> over and (re)wrote the bulk of the driver, getting things stable for
> >> production ship of Dream and Sapphire, and Dima is currently adding
> >> support for later Qualcomm chipsets (QSD8x50, etc).  Looping them into
> >> this discussion.
> >
> > I can maintain it if noone else steps up. Of course, someone who
> > actually knows the hw/has the docs would be preferable.
> 
> As Brian mentioned, I'm the last one to touch it here, so I now own
> it. I've done a bunch refactoring to add support for the qsd8x50

Can you submit a patch adding yourself into MAINTAINERS file?

> devices. I'll post those up onto our experimental git tree (hopefully
> sometime today), and once this patch goes in, I'll make sure that we
> apply cleanly against it. Alternatively, if you like, I can
> incorporate your comments into the refactoring work I'm doing, and can
> push out the combined patch. In the future though, I'll try to be a
> lot more aggressive at sending these out for review earlier so you
> don't have to clean up our mess.

I believe it makes sense to submit patches relative to -mm tree now.


> Please feel free to CC Rebecca and myself on all the msm_fb related
> changes/discussions.
> 
> >> It would probably be worth referring to drivers like this as "for
> >> Qualcomm MSM/QSD SoCs" or the like, since they do work with a lot of
> >> hardware beyond just Dream.
> >
> > Well, the Dream is why I'm doing it, hence patch title. Of course,
> > Kconfig should say 'Qualcomm MSM/QSD SoCs', too.
> 
> I second the request that the patches for qualcomm msm7k/qsd8k generic
> support would have descriptions that refer to them as such, since the
> htc dream specific code is only in the board files in
> arch/arm/mach-msm. Note that the HTC Magic (aka the Ion, myTouch 3G,

Ok, I guess someone should do a picture of all the connections and
dictionary of all the acronyms :-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
